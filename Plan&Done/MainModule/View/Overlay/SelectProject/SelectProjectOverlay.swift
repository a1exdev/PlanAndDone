//
//  SelectProjectOverlay.swift
//  Plan&Done
//
//  Created by Alexander Senin on 13.11.2022.
//

import UIKit

class SelectProjectOverlay: UIViewController {
    
    var presenter: MainViewPresenterProtocol!
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var insideView: UIView!
    
    @IBOutlet weak var inboxButton: UIView!
    @IBOutlet weak var noProjectButton: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    init() {
        super.init(nibName: "SelectProjectOverlay", bundle: nil)
        self.modalPresentationStyle = .overCurrentContext
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureGestures()
        configureTableView()
    }
    
    @IBAction func backViewTapped(_ sender: UIControl) {
        hide()
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        hide()
    }
    
    func appear(sender: UIViewController) {
        sender.present(self, animated: false) {
            self.show()
        }
    }
    
    private func configureView() {
        self.view.backgroundColor = .clear
        
        self.backView.backgroundColor = .black.withAlphaComponent(0.3)
        self.backView.alpha = 0
        
        self.contentView.alpha = 0
        self.contentView.layer.cornerRadius = 12
        self.contentView.clipsToBounds = true
        
        self.inboxButton.layer.cornerRadius = 8
        self.noProjectButton.layer.cornerRadius = 8
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInset = UIEdgeInsets(top: -35, left: 0, bottom: -30, right: 0)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "projectCell")
    }
    
    private func show() {
        self.contentView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        UIView.animate(withDuration: 0.2,
                       delay: 0,
                       animations: {
            self.backView.alpha = 1
            self.contentView.alpha = 1
            self.contentView.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
    }
    
    private func hide() {
        UIView.animate(withDuration: 0.2,
                       delay: 0,
                       animations: {
            self.backView.alpha = 0
            self.contentView.alpha = 0
            self.contentView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }, completion: { _ in
            self.dismiss(animated: true)
        })
    }
}

extension SelectProjectOverlay: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension SelectProjectOverlay: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let customProjectsCount = (presenter.projectGroups.last?.project?.allObjects as! [Project]).count
        return customProjectsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "projectCell", for: indexPath)
        
        let customProjects = presenter.projectGroups.last?.project?.allObjects as! [Project]
        
        cell.textLabel?.text = customProjects[indexPath.row].title
        cell.imageView?.image = UIImage(systemName: ProjectImage.pie.rawValue)
        cell.imageView?.tintColor = .systemBlue
        cell.backgroundColor = .clear
        cell.layer.cornerRadius = 8
        cell.clipsToBounds = true
        
        return cell
    }
}

extension SelectProjectOverlay: UIGestureRecognizerDelegate {
    
    @objc func buttonLongPressed(gestureReconizer: UILongPressGestureRecognizer) {
        
        let currentLocationY = gestureReconizer.location(in: insideView).y
        
        switch gestureReconizer.state {
        case .ended:
            switch currentLocationY {
            case (inboxButton.frame.minY)...(inboxButton.frame.maxY):
                UIView.animate(withDuration: 0.2, delay: 0) {
                    self.inboxButton.backgroundColor = UIColor(rgb: 0x2D3037)
                }
            case (noProjectButton.frame.minY)...(noProjectButton.frame.maxY):
                UIView.animate(withDuration: 0.2, delay: 0) {
                    self.noProjectButton.backgroundColor = UIColor(rgb: 0x2D3037)
                }
            default:
                break
            }
        default:
            switch currentLocationY {
            case (inboxButton.frame.minY)...(inboxButton.frame.maxY):
                UIView.animate(withDuration: 0.2, delay: 0) {
                    self.inboxButton.backgroundColor = .lightGray.withAlphaComponent(0.2)
                    self.noProjectButton.backgroundColor = UIColor(rgb: 0x2D3037)
                }
            case (noProjectButton.frame.minY)...(noProjectButton.frame.maxY):
                UIView.animate(withDuration: 0.2, delay: 0) {
                    self.noProjectButton.backgroundColor = .lightGray.withAlphaComponent(0.2)
                    self.inboxButton.backgroundColor = UIColor(rgb: 0x2D3037)
                }
            default:
                UIView.animate(withDuration: 0.2, delay: 0) {
                    self.inboxButton.backgroundColor = UIColor(rgb: 0x2D3037)
                    self.noProjectButton.backgroundColor = UIColor(rgb: 0x2D3037)
                }
            }
        }
    }
    
    private func configureGestures() {
        let longPressInboxButton = UILongPressGestureRecognizer(target: self, action: #selector(buttonLongPressed))
        longPressInboxButton.delegate = self
        longPressInboxButton.minimumPressDuration = 0
        inboxButton.addGestureRecognizer(longPressInboxButton)
        
        let longPressNoProjectButton = UILongPressGestureRecognizer(target: self, action: #selector(buttonLongPressed))
        longPressNoProjectButton.delegate = self
        longPressNoProjectButton.minimumPressDuration = 0
        noProjectButton.addGestureRecognizer(longPressNoProjectButton)
    }
}

extension SelectProjectOverlay: MainViewProtocol {
    
}
