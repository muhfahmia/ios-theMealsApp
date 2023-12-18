//
//  OnBoardingViewController.swift
//  ios-theMealsApp
//
//  Created by Muhammad Fahmi on 21/10/23.
//

import UIKit
import Combine
import Common
import Domain

public class OnBoardingViewController: UIViewController {
    
    @IBOutlet weak var boardCollectionView: UICollectionView!
    @IBOutlet weak var boardPageControl: UIPageControl!
    @IBOutlet weak var boardTitle: UILabel!
    @IBOutlet weak var boardDesc: UILabel!
    
    private var router: OnBoardingRouteCase
    private var boardViewModel: OnBoardViewModel
    private var cancelable = Set<AnyCancellable>()
    
    var boarding: [BoardPage]?
    
    public init(router: OnBoardingRouteCase, viewModel: OnBoardViewModel) {
        self.router = router
        self.boardViewModel = viewModel
        super.init(nibName: String(describing: OnBoardingViewController.self), bundle: Bundle.current)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupCellRegister()
        boardViewModel.get()
        boardViewModel.boardingPage
            .sink(receiveValue: { [weak self] value in
                self?.boarding = value
                self?.boardCollectionView.reloadData()
                self?.boardPageControl.numberOfPages = self?.boarding?.count ?? 0
                self?.setupBoard(with: 0)
            }).store(in: &cancelable)
    }
    
    func setupCollectionView() {
        let cvLayout = UICollectionViewFlowLayout()
        cvLayout.scrollDirection = .horizontal
        boardCollectionView.dataSource = self
        boardCollectionView.delegate = self
        boardCollectionView.showsHorizontalScrollIndicator = false
        boardCollectionView.isPagingEnabled = true
        boardCollectionView.collectionViewLayout = cvLayout
    }
    
    func setupCellRegister() {
        boardCollectionView.register(nibWithCellClass: OnBoardingCollectionViewCell.self, at: ModuleInjection.self)
    }
    
    func setupBoard(with page: Int) {
        boardPageControl.currentPage = page
        boardTitle.text = boarding?[page].title
        boardDesc.text = boarding?[page].desc
    }
    
    @IBAction func boardAction(_ sender: Any) {
        let indexPage = Int(boardCollectionView.contentOffset.x / boardCollectionView.frame.width) + 1
        let indexPath = IndexPath(row: indexPage, section: 0)
        
        if indexPage == boarding?.endIndex {
            router.routeToHome(from: self)
        } else {
            setupBoard(with: indexPage)
            boardCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let indexPage = Int(boardCollectionView.contentOffset.x / scrollView.frame.size.height)
        setupBoard(with: indexPage)
    }
}

extension OnBoardingViewController: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: OnBoardingCollectionViewCell = collectionView.dequeueReusableCell(withClass: OnBoardingCollectionViewCell.self, for: indexPath)
        let board = boarding?[indexPath.item]
        cell.configure(with: board)
        return cell
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return boarding?.count ?? 0
    }
    
}

extension OnBoardingViewController: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: boardCollectionView.bounds.width, height: boardCollectionView.bounds.height)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
