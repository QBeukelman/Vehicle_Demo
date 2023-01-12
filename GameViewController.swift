/* ************************************************************************** */
/*                                                                            */
/*                                                        ::::::::            */
/*   GameViewController.swift                           :+:    :+:            */
/*                                                     +:+                    */
/*   By: quentinbeukelman <quentinbeukelman@stud      +#+                     */
/*                                                   +#+                      */
/*   Created: 2022/03/28 10:23:30 by quentinbeuk   #+#    #+#                 */
/*   Updated: 2022/04/08 15:50:04 by quentinbeuk   ########   odam.nl         */
/*                                                                            */
/* ************************************************************************** */

import UIKit
import SceneKit

class GameViewController: UIViewController {
    
    // Vehicle Variables
    var sceneView: SCNView!
    var scene: SCNScene!
    var vehicle: SCNPhysicsVehicle!
    var steeringAxis: SCNVector3!
    var turnL: Int = 0
    var turnR: Int = 0
    var handBreak: Int = 0
    
    // UI Vairables
    var menuView: UIView!
    var beginMenuView: UIView!
    var blurEffectViewMenu: UIView!
    
    var beginMenuButton: UIButton!
    var handBreakButton: UIButton!
    var menuButton: UIButton!
    var leftButton: UIButton!
    var rightButton: UIButton!
    var beginPlanetsButton: UIButton!

    var screenSize: CGRect!
    
    var welcomeLabel: UILabel!
    var explainationLabel: UILabel!
    var marsLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        screenSize = UIScreen.main.bounds
        
        setUpPlanetsScene()
        addBeginingView()

    }
    
    
    // MARK: - addMenuView
    func addMenuView() {
        
        menuView = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: 300))
        menuView.layer.backgroundColor = UIColor.red.cgColor
        
        let exitMenuButton = UIButton(type: .system)
            exitMenuButton.tintColor = UIColor.black
            exitMenuButton.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 25)
            exitMenuButton.setTitle("Resume", for: .normal)
            exitMenuButton.sizeToFit()
            exitMenuButton.addTarget(self, action: #selector(didPressExitMenu), for: .touchUpInside)
        exitMenuButton.center.x = screenSize.width/2
            exitMenuButton.center.y = 150
        
        menuView.addSubview(exitMenuButton)
        
        self.view.addSubview(menuView)
        menuView.isHidden = true
    }
    
    
    func addPlanetsView() {
        beginPlanetsButton = UIButton(type: .system)
        beginPlanetsButton.tintColor = UIColor.black
        beginPlanetsButton.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 25)
        beginPlanetsButton.setTitleColor(UIColor.white, for: .normal)
        beginPlanetsButton.setTitle("Land", for: .normal)
        beginPlanetsButton.backgroundColor = UIColor.blue
        beginPlanetsButton.layer.cornerRadius = 10
        beginPlanetsButton.frame.size = CGSize(width: screenSize.width-40, height: 60)
        beginPlanetsButton.addTarget(self, action: #selector(didBeginPlanetsGo), for: .touchUpInside)
        beginPlanetsButton.center.x = (screenSize.width/2)
        beginPlanetsButton.center.y = (screenSize.height-100)
        self.view.addSubview(beginPlanetsButton)
        
        marsLabel = UILabel(frame: CGRect(x: 0, y: 0,width: screenSize.width-40, height: screenSize.height/3))
        marsLabel.textColor = UIColor.white
        marsLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 36)
        marsLabel.center.x = screenSize.width/2
        marsLabel.center.y = 100
        marsLabel.numberOfLines = 3
        marsLabel.textAlignment = .center
        marsLabel.text = "The Red Planet"
        self.view.addSubview(marsLabel)

    }
    

    // MARK: - addBeginingView
    func addBeginingView() {
        
        beginMenuView = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.width))
        beginMenuView.layer.backgroundColor = UIColor.red.cgColor
    
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        blurEffectViewMenu = UIVisualEffectView(effect: blurEffect)
        blurEffectViewMenu.frame = view.bounds
        blurEffectViewMenu.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(blurEffectViewMenu)
        
        welcomeLabel = UILabel(frame: CGRect(x: 0, y: 0,width: screenSize.width-40, height: screenSize.height/3))
        welcomeLabel.textColor = UIColor.white
        welcomeLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 36)
        welcomeLabel.center.x = screenSize.width/2
        welcomeLabel.center.y = 200
        welcomeLabel.numberOfLines = 3
        welcomeLabel.textAlignment = .center
        welcomeLabel.text = "Welcome to the Mars Curiosity Rover vehicle physics demo"
        self.view.addSubview(welcomeLabel)
        
        explainationLabel = UILabel(frame: CGRect(x: 0, y: 0,width: screenSize.width-40, height: screenSize.height/3))
        explainationLabel.textColor = UIColor.white
        explainationLabel.font = UIFont(name: "HelveticaNeue", size: 17)
        explainationLabel.center.x = screenSize.width/2
        explainationLabel.center.y = screenSize.height/2
        explainationLabel.numberOfLines = 3
        explainationLabel.textAlignment = .center
        explainationLabel.text = "The Curiosity Rover accelarates automatically. Press 'Left' + 'Right' to apply the breaks."
        self.view.addSubview(explainationLabel)
        
        beginMenuButton = UIButton(type: .system)
        beginMenuButton.tintColor = UIColor.black
        beginMenuButton.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 25)
        beginMenuButton.setTitleColor(UIColor.white, for: .normal)
        beginMenuButton.setTitle("Begin", for: .normal)
        beginMenuButton.backgroundColor = UIColor.blue
        beginMenuButton.layer.cornerRadius = 10
        beginMenuButton.frame.size = CGSize(width: screenSize.width-40, height: 60)
        beginMenuButton.addTarget(self, action: #selector(didBeginMenuGo), for: .touchUpInside)
        beginMenuButton.center.x = (screenSize.width/2)
        beginMenuButton.center.y = (screenSize.height-100)
        self.view.addSubview(beginMenuButton)
        
        self.view.addSubview(beginMenuView)
        beginMenuView.isHidden = true
        blurEffectViewMenu.isHidden = false
        
    }
    
    
    // MARK: - setUpScene
    func setUpPlanetsScene() {
        sceneView = self.view as? SCNView
        sceneView.allowsCameraControl = true
        scene = SCNScene(named: "planetsMenu.scn")
        sceneView.scene = scene
        
    }
    
    func setUpCarScene() {
        sceneView = self.view as? SCNView
        sceneView.allowsCameraControl = false
        scene = SCNScene(named: "MainScene.scn")
        sceneView.scene = scene
        
    }
    
    
    // MARK: - setUpCar
    func setUpCar() {

        let chassisNode = scene!.rootNode.childNode(withName: "car", recursively: true)!
        
        let body = SCNPhysicsBody.dynamic()
            body.allowsResting = false
            body.mass = 200
            body.restitution = 0.1
            body.friction = 0
            body.rollingFriction = 1
            chassisNode.physicsBody = body
            scene.rootNode.addChildNode(chassisNode)
        
        // Add Wheels
        let wheelnode0 = chassisNode.childNode(withName: "wheelLocator_FL", recursively: true)!
        let wheelnode1 = chassisNode.childNode(withName: "wheelLocator_FR", recursively: true)!
        let wheelnode2 = chassisNode.childNode(withName: "wheelLocator_RL", recursively: true)!
        let wheelnode3 = chassisNode.childNode(withName: "wheelLocator_RR", recursively: true)!
        let wheel0 = SCNPhysicsVehicleWheel(node: wheelnode0)
        let wheel1 = SCNPhysicsVehicleWheel(node: wheelnode1)
        let wheel2 = SCNPhysicsVehicleWheel(node: wheelnode2)
        let wheel3 = SCNPhysicsVehicleWheel(node: wheelnode3)
        let min = SCNVector3(x: 0, y: 0, z: 0)
        let max = SCNVector3(x: 0, y: 0, z: 0)
        wheelnode0.boundingBox.max = max
        wheelnode0.boundingBox.min = min
    
        wheel0.suspensionStiffness = 2
        wheel1.suspensionStiffness = 2
        wheel2.suspensionStiffness = 5
        wheel3.suspensionStiffness = 5
        
        wheel0.maximumSuspensionTravel = 1000
        wheel1.maximumSuspensionTravel = 1000
        wheel2.maximumSuspensionTravel = 1000
        wheel3.maximumSuspensionTravel = 1000

        wheel0.suspensionRestLength = 0.5
        wheel1.suspensionRestLength = 0.5
        wheel2.suspensionRestLength = 0.5
        wheel3.suspensionRestLength = 0.5
        
        wheel0.frictionSlip = 1
        wheel1.frictionSlip = 1
        wheel2.frictionSlip = 5.5
        wheel3.frictionSlip = 5.5
        
        let wheelHalfWidth = Float(0.5 * (max.x - min.x))
        SCNVector3Make(wheelHalfWidth * 5.2, 0, 0)
        
        vehicle = SCNPhysicsVehicle(chassisBody: chassisNode.physicsBody!, wheels: [wheel1, wheel0, wheel3, wheel2])
        scene.physicsWorld.addBehavior(vehicle)
        
    }
    
    
    // MARK: - addUserInterface
    func addUserInterface() {

        menuButton = UIButton(type: .system)
            menuButton.tintColor = UIColor.black
            menuButton.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 17)
            menuButton.setTitle("Menu", for: .normal)
            menuButton.sizeToFit()
            menuButton.addTarget(self, action: #selector(didPressMenu), for: .touchUpInside)
            menuButton.center.x = (screenSize.width/2)
            menuButton.frame.origin.y = (screenSize.height-70)
        sceneView.addSubview(menuButton)
        
        handBreakButton = UIButton(type: .system)
            handBreakButton.tintColor = UIColor.black
            handBreakButton.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 17)
            handBreakButton.setTitle("Hand Break", for: .normal)
            handBreakButton.sizeToFit()
            handBreakButton.addTarget(self, action: #selector(didPressHandBreak), for: .touchUpInside)
            handBreakButton.center.x = (screenSize.width/2)
            handBreakButton.frame.origin.y = (screenSize.height-120)
        sceneView.addSubview(handBreakButton)
        
        // Streeing
        leftButton = UIButton(type: .system)
            leftButton.tintColor = UIColor.black
            leftButton.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 25)
            leftButton.setTitle("Left", for: .normal)
            leftButton.frame.size = CGSize(width: 120, height: 60)
            leftButton.layer.borderWidth = 2
            leftButton.layer.borderColor = UIColor.red.cgColor
            leftButton.addTarget(self, action: #selector(didPressLeft), for: .touchDown)
            leftButton.addTarget(self, action: #selector(didReleaseLeftStreeing), for: .touchUpInside)
            leftButton.center.x = 50
        leftButton.center.y = (screenSize.height-100)
        sceneView.addSubview(leftButton)
        
        rightButton = UIButton(type: .system)
            rightButton.tintColor = UIColor.black
            rightButton.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 25)
            rightButton.setTitle("Right", for: .normal)
            rightButton.frame.size = CGSize(width: 120, height: 60)
            rightButton.layer.borderWidth = 2
            rightButton.layer.borderColor = UIColor.red.cgColor
            rightButton.addTarget(self, action: #selector(didPressRight), for: .touchDown)
            rightButton.addTarget(self, action: #selector(didReleaseRightStreeing), for: .touchUpInside)
            rightButton.center.x = (screenSize.width-50)
        rightButton.center.y = (screenSize.height-100)
        sceneView.addSubview(rightButton)
        
    }
    
    
    
    // MARK: - engineForce
    func engineForce() {
        
        vehicle.applyBrakingForce(0, forWheelAt: 0)
        vehicle.applyBrakingForce(0, forWheelAt: 1)
        vehicle.applyBrakingForce(0, forWheelAt: 2)
        vehicle.applyBrakingForce(0, forWheelAt: 3)
        
        vehicle.applyEngineForce(-35, forWheelAt: 2)
        vehicle.applyEngineForce(-35, forWheelAt: 3)
    }
    
    // MARK: - brakingForce
    func brakingForce() {
        
        vehicle.applyBrakingForce(1, forWheelAt: 0)
        vehicle.applyBrakingForce(1, forWheelAt: 1)
        vehicle.applyBrakingForce(10, forWheelAt: 2)
        vehicle.applyBrakingForce(10, forWheelAt: 3)
        
        vehicle.setSteeringAngle(0, forWheelAt: 0)
        vehicle.setSteeringAngle(0, forWheelAt: 1)
    }
    
    
    // MARK: - brakingForce
    func brakingForceTurnButtons() {
        
        if turnL == 1 && turnR == 1 {
            brakingForce()
        } else {
            engineForce()
        }
    }
    
    
    // MARK: - handBreak
    func handBreakCar() {
        
        if handBreak == 0 {
            // Hand Break ON
            handBreak = 1
            brakingForce()
            handBreakButton.setTitle("GO", for: .normal)
        } else if handBreak == 1 {
            // Hand Break OFF
            handBreak = 0
            engineForce()
            handBreakButton.setTitle("Hand Break", for: .normal)
        }
    }

    
    
    // MARK: - UI Buttons
    @objc func didPressHandBreak (sender: UIButton!) {
        handBreakCar()
    }
    
    @objc func didBeginMenuGo (sender: UIButton!) {
        beginMenuView.isHidden = true
        blurEffectViewMenu.isHidden = true
        beginMenuButton.isHidden = true
        welcomeLabel.isHidden = true
        explainationLabel.isHidden = true
        addPlanetsView()
    }
    
    
    @objc func didBeginPlanetsGo (sender: UIButton!) {
        beginPlanetsButton.isHidden = true
        marsLabel.isHidden = true
        setUpCarScene()
        setUpCar()
        addUserInterface()
        addMenuView()
        engineForce()
    }
    
    
    @objc func didPressMenu (sender: UIButton!) {
        vehicle.applyBrakingForce(1, forWheelAt: 0)
        vehicle.applyBrakingForce(1, forWheelAt: 1)
        vehicle.applyBrakingForce(10, forWheelAt: 2)
        vehicle.applyBrakingForce(10, forWheelAt: 3)
        
        vehicle.setSteeringAngle(0, forWheelAt: 0)
        vehicle.setSteeringAngle(0, forWheelAt: 1)
        menuView.isHidden = false
        
        handBreakButton.isEnabled = false
        menuButton.isEnabled = false
        leftButton.isEnabled = false
        rightButton.isEnabled = false
    }
    
    @objc func didPressExitMenu (sender: UIButton!) {
        engineForce()
        menuView.isHidden = true
        
        handBreakButton.isEnabled = true
        menuButton.isEnabled = true
        leftButton.isEnabled = true
        rightButton.isEnabled = true
    }
    
    @objc func didPressLeft (sender: UIButton!) {
        vehicle.setSteeringAngle(0.5, forWheelAt: 0)
        vehicle.setSteeringAngle(0.5, forWheelAt: 1)
        turnL = 1
        brakingForceTurnButtons()
    }
    
    @objc func didPressRight(sender: UIButton!) {
        vehicle.setSteeringAngle(-0.5, forWheelAt: 0)
        vehicle.setSteeringAngle(-0.5, forWheelAt: 1)
        turnR = 1
        brakingForceTurnButtons()
    }
    
    @objc func didReleaseLeftStreeing (sender: UIButton!) {
        vehicle.setSteeringAngle(0, forWheelAt: 0)
        vehicle.setSteeringAngle(0, forWheelAt: 1)
        turnL = 0
        brakingForceTurnButtons()
    }
    
    @objc func didReleaseRightStreeing (sender: UIButton!) {
        vehicle.setSteeringAngle(0, forWheelAt: 0)
        vehicle.setSteeringAngle(0, forWheelAt: 1)
        turnR = 0
        brakingForceTurnButtons()
    }
    
    
    // MARK: - Settings
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    

} // End Class
