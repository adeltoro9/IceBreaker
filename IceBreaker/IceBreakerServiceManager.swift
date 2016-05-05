//
//  IceBreakerServiceManager.swift
//  BasicMessenger
//
//  Created by Anthony Del Toro on 4/18/16.
//  Copyright © 2016 AnthonyDDelToro. All rights reserved.
//

import UIKit
import MultipeerConnectivity
import NotificationCenter

class IceBreakerServiceManager: NSObject
{
    var recentPackets: [IBPacket] = [IBPacket]()
    var recentUsers: [IBUser] = [IBUser]()
    
    var publicConversations: [IBPacketType : IBConversation]! = [IBPacketType : IBConversation]()
    var privateConversations: [NSUUID : IBConversation]! = [NSUUID : IBConversation]()
    
    private let serviceAdvertiser : MCNearbyServiceAdvertiser
    private let serviceBrowser : MCNearbyServiceBrowser
    private let mySession : MCSession
    
    private let bConnectToPeersAutomatically : Bool
    
    var delegate : IceBreakerServiceManagerDelegate?
    
    init(connectToPeersAutomatically: Bool)
    {
        serviceAdvertiser = MCNearbyServiceAdvertiser(peer: myUserProfile.peerID, discoveryInfo: nil, serviceType: IceBreakerServiceType)
        serviceBrowser = MCNearbyServiceBrowser(peer: myUserProfile.peerID, serviceType: IceBreakerServiceType)
        mySession = MCSession(peer: myUserProfile.peerID, securityIdentity: nil, encryptionPreference: MCEncryptionPreference.Required)
        
        bConnectToPeersAutomatically = connectToPeersAutomatically
        
        super.init()
        
        mySession.delegate = self
        
        serviceAdvertiser.delegate = self
        serviceAdvertiser.startAdvertisingPeer()
        print("Started advertising...")
        
        if (bConnectToPeersAutomatically)
        {
            serviceBrowser.delegate = self
            serviceBrowser.startBrowsingForPeers()
            print("Started browsing...")
        }
    }
    
    deinit
    {
        mySession.disconnect()
        
        serviceAdvertiser.stopAdvertisingPeer()
        print("Stopped advertising.")
        
        if (bConnectToPeersAutomatically)
        {
            serviceBrowser.stopBrowsingForPeers()
            print("Stopped browsing.")
        }
    }
    
    lazy var session : MCSession =
    {
        return self.mySession
    }()
    
    lazy var browser : MCNearbyServiceBrowser =
    {
        return self.serviceBrowser
    }()
    
    func reconnect()
    {
        serviceAdvertiser.startAdvertisingPeer()
        print("Started advertising...")
        
        if (bConnectToPeersAutomatically)
        {
            serviceBrowser.startBrowsingForPeers()
            print("Started browsing...")
        }
    }
    
    func disconnect()
    {
        print(self.recentPackets.count)
        
        print(NSThread.callStackSymbols())
        
        mySession.disconnect()
        
        serviceAdvertiser.stopAdvertisingPeer()
        print("Stopped advertising.")
        
        if (bConnectToPeersAutomatically)
        {
            serviceBrowser.stopBrowsingForPeers()
            print("Stopped browsing.")
        }
    }
    
    func resetConnection()
    {
        mySession.disconnect()
        
        serviceAdvertiser.stopAdvertisingPeer()
        print("Stopped advertising.")
        
        if (bConnectToPeersAutomatically)
        {
            serviceBrowser.stopBrowsingForPeers()
            print("Stopped browsing.")
        }
        
        serviceAdvertiser.startAdvertisingPeer()
        print("Started advertising...")
        
        if (bConnectToPeersAutomatically)
        {
            serviceBrowser.startBrowsingForPeers()
            print("Started browsing...")
        }
    }
    
    func getIBUserFromUsername(username: String) -> IBUser?
    {
        for usr in recentUsers
        {
            if (usr.username == username)
            {
                return usr
            }
        }
        
        return nil
    }
    
    func getIBUserFromUUID(uuid: NSUUID) -> IBUser?
    {
        for usr in recentUsers
        {
            if (usr.uuid == uuid)
            {
                return usr
            }
        }
        
        return nil
    }
    
//# MARK: Packet Processing Methods
    func sendPacket(ibPacket: IBPacket, bPrintMessageToScreen: Bool) -> Bool
    {
        var bSuccess: Bool = true
        
        if session.connectedPeers.count > 0
        {
            do
            {
                    let packetData = NSKeyedArchiver.archivedDataWithRootObject(ibPacket)
                try self.session.sendData(packetData, toPeers: session.connectedPeers, withMode: .Reliable)
            }
            catch
            {
                bSuccess = false
            }
        }
        else
        {
            bSuccess = false
        }
        
        if (bPrintMessageToScreen && bSuccess)
        {
            print("sendPacket")
            self.delegate?.refreshMessageScreen(self)
        }
        
        return bSuccess
    }
    
    func checkForPacketAndSender(ibp: IBPacket) -> Bool
    {
        var i: Int = 0
        
        while i < recentPackets.count
        {
            if (ibp.uniqueID == recentPackets[i].uniqueID)
            {
                return true
            }
            else if (NSDate().timeIntervalSinceDate(recentPackets[i].timeStamp) > (3 * 60))
            {
                recentPackets.removeAtIndex(i)
                i -= 1
            }
            
            i += 1
        }

        recentPackets.append(ibp)
        
        i = 0
        
        var bAddSender = true
        
        while i < recentUsers.count
        {
            if (ibp.sender.uuid == recentUsers[i].uuid)
            {
                bAddSender = false
                break
            }
        }
        
        if (bAddSender)
        {
            recentUsers.append(ibp.sender)
        }
        
        print("recentUsers: \(recentUsers.count)")
        
        return false
    }
    
    func processPacket(ibp: IBPacket)
    {
        if (checkForPacketAndSender(ibp))
        {
            // packet was found and so we have already processed it
            return
        }
        
        var bForwardMessage: Bool = true
        
        switch ibp.type
        {
        case .Private:
            if (ibp.recipient?.uuid == myUserProfile.myUUID)
            {
                // private message is for me!
                bForwardMessage = false
                print("processPacket - Private")
                if let conv = privateConversations[ibp.sender.uuid]
                {
                    if (conv.Recipient != ibp.sender)
                    {
                        print("updating recipient info.")
                        let index = recentUsers.indexOf(conv.Recipient!)!
                        recentUsers.removeAtIndex(index)
                        conv.Recipient = ibp.sender
                        recentUsers.insert(conv.Recipient!, atIndex: index)
                    }
                    conv.addNewMessage(ibp)
                }
                else
                {
                    privateConversations[ibp.sender.uuid] = IBConversation(topic: .Private, recipient: ibp.sender)
                    privateConversations[ibp.sender.uuid]!.addNewMessage(ibp)
                }
                self.delegate?.refreshMessageScreen(ibsm)
            }
        case .PingQuery:
            if (ibp.recipient?.uuid == myUserProfile.myUUID)
            {
                bForwardMessage = false
                sendPacket(IBPacket(sender: myUserProfile.getIBUserObj(), recipient: ibp.sender, type: IBPacketType.PingResponse, message: "I'm here!", timeStamp: NSDate(), lifeTime: DEFAULT_LIFETIME), bPrintMessageToScreen: false)
            }
        case .PingResponse:
            if (ibp.recipient?.uuid == myUserProfile.myUUID)
            {
                bForwardMessage = false
                print("processPacket - PingResponse")
                self.delegate?.refreshMessageScreen(ibsm)
                //strMessage: "Ping response from \(ibp.sender.displayName)")
            }
        case .Politics:
            processPublicMessage(ibp, type: .Politics)
        case .Sports:
            processPublicMessage(ibp, type: .Sports)
        case .MUEvents:
            processPublicMessage(ibp, type: .MUEvents)
        default:
            let avc = UIAlertController(title: "Unknown Packet Type", message: "A packet was received from \(ibp.sender.peerID.displayName) that could not be processed.", preferredStyle: .Alert)
            let dismiss = UIAlertAction(title: "Dismiss", style: .Cancel, handler: nil)
            avc.addAction(dismiss)
            UIApplication.topViewController()!.presentViewController(avc, animated: true, completion: nil)
        }
        
        if (bForwardMessage)
        {
            if(!forwardPacket(ibp))
            {
                let avc = UIAlertController(title: "Could not forward packet", message: "A packet \(ibp.uniqueID) that was received from \(ibp.sender.username) (\(ibp.sender.uuid)) could not be forwarded.", preferredStyle: .Alert)
                let dismiss = UIAlertAction(title: "Dismiss", style: .Cancel, handler: nil)
                avc.addAction(dismiss)
                UIApplication.topViewController()!.presentViewController(avc, animated: true, completion: nil)
            }
        }
    }
    
    func forwardPacket(ibp: IBPacket) -> Bool
    {
        var recipients = session.connectedPeers

        var i: Int = 0
        
        while (i < recipients.count)
        {
            //print(recipients[i].displayName + " v. " + ibp.sender.peerID.displayName)
            if recipients[i].displayName == ibp.sender.peerID.displayName
            {
                recipients.removeAtIndex(i)
                break
            }
            i += 1
        }
        
        var bSuccess: Bool = true
        
        if recipients.count > 0
        {
            do
            {
                let packetData = NSKeyedArchiver.archivedDataWithRootObject(ibp)
                try self.session.sendData(packetData, toPeers: recipients, withMode: .Reliable)
            }
            catch
            {
                bSuccess = false
            }
        }
        
        return bSuccess
    }
    
    func processPublicMessage(ibp: IBPacket, type: IBPacketType)
    {
        if let conv = publicConversations[type]
        {
            conv.addNewMessage(ibp)
            
            if let mvc = (self.delegate as? MessagesViewController)
            {
                if (mvc.Conversation.topic == ibp.type)
                {
                    print("processPublicMessage")
                    //self.delegate?.printMessageToScreen(self, ibp: ibp)
                    self.delegate?.refreshMessageScreen(self)
                }
            }
        }
    }
}

//# MARK: IceBreakerServiceManagerDelegate Protocol
protocol IceBreakerServiceManagerDelegate
{
    func connectedDevicesChanged(manager: IceBreakerServiceManager, connectedDevices: [String])
    //func printMessageToScreen(manager: IceBreakerServiceManager, ibp: IBPacket)
    func refreshMessageScreen(manager: IceBreakerServiceManager)
}

//# MARK: - MCNearbyServiceAdvertiserDelegate Protocol
extension IceBreakerServiceManager: MCNearbyServiceAdvertiserDelegate
{
    func advertiser(advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: NSData?,invitationHandler: (Bool, MCSession) -> Void)
    {
        /*
         Parameters
         advertiser
         The advertiser object that was invited to join the session.
         peerID
         The peer ID of the nearby peer that invited your app to join the session.
         context
         An arbitrary piece of data received from the nearby peer. This can be used to provide further information to the user about the nature of the invitation.
         IMPORTANT
         The nearby peer should treat any data it receives as potentially untrusted. To learn more about working with untrusted data, read Secure Coding Guide.
         invitationHandler
         A block that your code must call to indicate whether the advertiser should accept or decline the invitation, and to provide a session with which to associate the peer that sent the invitation.
         */
        
        //self.delegate?.printMessageToScreen(self, strMessage: ("Received invitation from \(peerID.displayName)"))
        
        if (bConnectToPeersAutomatically)
        {
            // Automatically accept
            invitationHandler(true, self.session)
        }
        else
        {
            // Ask user if they wish to accept the invitation
            let avc = UIAlertController(title: "New Invitation", message: "Would you like to connect with \(peerID.displayName)?", preferredStyle: .Alert)
            
            let yes = UIAlertAction(title: "Yes", style: .Default)
            { (action) in
                invitationHandler(true, self.session)
            }
            
            let no = UIAlertAction(title: "No", style: .Cancel)
            { (action) in
                invitationHandler(false, self.session)
            }
            
            avc.addAction(no)
            
            avc.addAction(yes)
            
            UIApplication.topViewController()!.presentViewController(avc, animated: true, completion: nil)
        }
    }
    
    func advertiser(advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: NSError)
    {
        // Alert user if we were unable to start advertising
        
        let avc = UIAlertController(title: "Connection Error", message: "Failed to start advertising service.\nPlease try again later.", preferredStyle: .Alert)
        
        let dismiss = UIAlertAction(title: "Dismiss", style: .Cancel, handler: nil)
        
        avc.addAction(dismiss)
        
        UIApplication.topViewController()!.presentViewController(avc, animated: true, completion: nil)
        
        var strErrorMessage: String = error.description
        
        if let strFailureReason = error.localizedFailureReason
        {
            strErrorMessage = strErrorMessage + "\n" + strFailureReason
        }
        
        print(strErrorMessage)
    }
}

//# MARK: - MCNearbyServiceBrowserDelegate Protocol
extension IceBreakerServiceManager: MCNearbyServiceBrowserDelegate
{
    func browser(browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?)
    {
        /*
         Parameters
         browser
         The browser object that found the nearby peer.
         peerID
         The unique ID of the peer that was found.
         info
         The info dictionary advertised by the discovered peer. For more information on the contents of this dictionary, see the documentation for initWithPeer:discoveryInfo:serviceType: in MCNearbyServiceAdvertiser Class Reference.
         Discussion
         The peer ID provided to this delegate method can be used to invite the nearby peer to join a session.
        */
        //self.delegate?.printMessageToScreen(self, strMessage: "Found new peer: \(peerID.displayName)!")
        
        browser.invitePeer(peerID, toSession: self.session, withContext: nil, timeout: 50)
        
        //self.delegate?.printMessageToScreen(self, strMessage: "Inviting \(peerID.displayName)!")
        print("Found new peer: \(peerID.displayName)!")
        print("Inviting \(peerID.displayName)!")
    }
    
    func browser(browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID)
    {
        /*
         Parameters
         browser
         The browser object that lost the nearby peer.
         peerID
         The unique ID of the nearby peer that was lost.
         Discussion
         This callback informs your app that invitations can no longer be sent to a peer, and that your app should remove that peer from its user interface.
         
         IMPORTANT
         Because there is a delay between when a host leaves a network and when the underlying Bonjour layer detects that it has left, the fact that your app has not yet received a disappearance callback does not guarantee that it can communicate with the peer successfully.
        */
        
        //self.delegate?.printMessageToScreen(self, strMessage: "Lost connection to \(peerID.displayName) :'(")
        print("Lost connection to \(peerID.displayName) :'(")
    }
    
    func browser(browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: NSError)
    {
        // Alert user if we were unable to start browsing
        
        let avc = UIAlertController(title: "Connection Error", message: "Failed to start browsing service.\nPlease try again later.", preferredStyle: .Alert)
        
        let dismiss = UIAlertAction(title: "Dismiss", style: .Cancel, handler: nil)
        
        avc.addAction(dismiss)
        
        UIApplication.topViewController()!.presentViewController(avc, animated: true, completion: nil)
        
        var strErrorMessage: String = error.description
        
        if let strFailureReason = error.localizedFailureReason
        {
            strErrorMessage = strErrorMessage + "\n" + strFailureReason
        }
        
        print(strErrorMessage)
    }
}

//# MARK: - MCSessionDelegate Protocol

extension IceBreakerServiceManager: MCSessionDelegate
{
    func session(session: MCSession, peer peerID: MCPeerID, didChangeState state: MCSessionState)
    {
        /*
         Parameters
         session
         The session that manages the nearby peer whose state changed.
         peerID
         The ID of the nearby peer whose state changed.
         state
         The new state of the nearby peer.
         Discussion
         This delegate method is called with the following state values when the nearby peer’s state changes:
         
         MCSessionStateConnected—the nearby peer accepted the invitation and is now connected to the session.
         
         MCSessionStateNotConnected—the nearby peer declined the invitation, the connection could not be established, or a previously connected peer is no longer connected.
        */
        
        //self.delegate?.printMessageToScreen(self, strMessage: "State " + state.stringValue())
        
        var aPeers: [String] = [String]()
        
        for peer in session.connectedPeers
        {
            aPeers.append(peer.displayName)
        }
        
        self.delegate?.connectedDevicesChanged(self, connectedDevices: aPeers)
    }
    
    func session(session: MCSession, didReceiveData data: NSData, fromPeer peerID: MCPeerID)
    {
        /*
         Parameters
         session
         The session through which the data was received.
         data
         An object containing the received data.
         peerID	
         The peer ID of the sender.
        */
        
        //var strNewMessage = NSString(data: data, encoding: NSUTF8StringEncoding) as! String
        
        if let ibp = (NSKeyedUnarchiver.unarchiveObjectWithData(data) as? IBPacket)
        {
            processPacket(ibp)
        }
    }
    
    func session(session: MCSession, didReceiveStream stream: NSInputStream, withName streamName: String, fromPeer peerID: MCPeerID)
    {
        /*
         Parameters
         session
         The session through which the byte stream was opened.
         stream
         An NSInputStream object that represents the local endpoint for the byte stream.
         streamName
         The name of the stream, as provided by the originator.
         peerID	
         The peer ID of the originator of the stream.
        */
        //self.delegate?.printMessageToScreen(self, strMessage: "Got stream from \(peerID.displayName)")
    }
    
    func session(session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, withProgress progress: NSProgress)
    {
        /*
         Parameters
         session
         The session that started receiving the resource.
         resourceName
         The name of the resource, as provided by the sender.
         peerID
         The sender’s peer ID.
         progress
         An NSProgress object that can be used to cancel the transfer or queried to determine how far the transfer has progressed.
        */
        //self.delegate?.printMessageToScreen(self, strMessage: "Receiving \(resourceName) from \(peerID.displayName)...")
        print("Receiving \(resourceName) from \(peerID.displayName)...")
    }
    
    func session(session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, atURL localURL: NSURL, withError error: NSError?)
    {
        /*
         Parameters
         session
         The session through which the data was received.
         resourceName
         The name of the resource, as provided by the sender.
         peerID
         The peer ID of the sender.
         localURL
         An NSURL object that provides the location of a temporary file containing the received data.
         error
         An error object indicating what went wrong if the file was not received successfully, or nil.
         Discussion
         The file referenced by localURL is a temporary file. Your app must either read the file or make a copy in a permanent location before this delegate method returns.
        */
        //self.delegate?.printMessageToScreen(self, strMessage: "Successfully received \(resourceName) from \(peerID.displayName)!")
        print("Successfully received \(resourceName) from \(peerID.displayName)!")
    }
    
    /*
    func session(session: MCSession, didReceiveCertificate certificate: [AnyObject]?, fromPeer peerID: MCPeerID, certificateHandler: (Bool) -> Void)
    {
        /*
         Parameters
         session
         The session that the nearby peer wishes to join.
         certificate
         A certificate chain, presented as an array of SecCertificateRef certificate objects. The first certificate in this chain is the peer’s certificate, which is derived from the identity that the peer provided when it called the initWithPeer:securityIdentity:encryptionPreference: method. The other certificates are the (optional) additional chain certificates provided in that same array.
         
         If the nearby peer did not provide a security identity, then this parameter’s value is nil.
         peerID
         The peer ID of the sender.
         certificateHandler
         Your app should call this handler with a value of true if the nearby peer should be allowed to join the session, or false otherwise.
         Discussion
         Your app should inspect the nearby peer’s certificate, and then should decide whether to trust that certificate. Upon making that determination, your app should call the provided certificateHandler block, passing either true (to trust the nearby peer) or false (to reject it).
         
         For information about validating certificates, read Cryptographic Services Guide. -> https://developer.apple.com/library/ios/documentation/Security/Conceptual/cryptoservices/Introduction/Introduction.html#//apple_ref/doc/uid/TP40011172
        */
        PrintMessageToScreen("Received certificate from \(peerID.displayName)")
        
        certificateHandler(true)
    }
    */
}

extension MCSessionState
{
    
    func stringValue() -> String
    {
        switch(self)
        {
            case .NotConnected:
                return "Not Connected"
            case .Connecting:
                return "Connecting"
            case .Connected:
                return "Connected"
            default:
                return "Unknown"
        }
    }
    
}