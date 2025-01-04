//
//  RecipeViewModel.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2020/12/27.
//  Copyright © 2020 shusuke. All rights reserved.
//

import KDRepository
import KDEntity
import KSFeatures
import RxCocoa
import RxSwift
import UIKit.UITableView

public protocol RecipeViewModelInput {
    var itemSelected: AnyObserver<IndexPath> { get }

    func loadRecipes(kikurageUserID: String)
}

public protocol RecipeViewModelOutput {
    var recipes: Observable<[KikurageRecipeTuple]> { get }
    var recipe: Observable<KikurageRecipeTuple> { get }
    var error: Observable<Error> { get }
}

public protocol RecipeViewModelType {
    var input: RecipeViewModelInput { get }
    var output: RecipeViewModelOutput { get }
}

public class RecipeViewModel: RecipeViewModelType, RecipeViewModelInput, RecipeViewModelOutput {
    private let recipeRepository: RecipeRepositoryProtocol

    private let disposeBag = RxSwift.DisposeBag()
    private let subject = PublishSubject<[KikurageRecipeTuple]>()
    private let errorSubject = PublishSubject<Error>()

    public var input: RecipeViewModelInput { self }
    public var output: RecipeViewModelOutput { self }

    public var itemSelected: AnyObserver<IndexPath>

    public var recipes: Observable<[KikurageRecipeTuple]> { subject.asObservable() }
    public var recipe: Observable<KikurageRecipeTuple>
    public var error: Observable<Error> { errorSubject.asObserver() }

    public init(recipeRepository: RecipeRepositoryProtocol) {
        self.recipeRepository = recipeRepository

        // for selected table view item
        let _recipe = PublishRelay<KikurageRecipeTuple>()
        recipe = _recipe.asObservable()

        let _itemSelected = PublishRelay<IndexPath>()
        itemSelected = AnyObserver<IndexPath> { event in
            guard let indexPath = event.element else {
                return
            }
            _itemSelected.accept(indexPath)
        }

        _itemSelected
            .withLatestFrom(recipes) { ($0.row, $1) }
            .flatMap { index, recipes -> Observable<KikurageRecipeTuple> in
                guard index < recipes.count else {
                    return .empty()
                }
                return .just(recipes[index])
            }
            .bind(to: _recipe)
            .disposed(by: disposeBag)
    }
}

// MARK: - Data Setting

extension RecipeViewModel {
    private func sortRecipes(recipes: [KikurageRecipeTuple]) -> [KikurageRecipeTuple] {
        recipes.sorted { recipe1, recipe2 -> Bool in
            guard let recipeDate1 = DateHelper.formatToDate(dateString: recipe1.data.cookDate) else {
                return false
            }
            guard let recipeDate2 = DateHelper.formatToDate(dateString: recipe2.data.cookDate) else {
                return false
            }
            return recipeDate1 > recipeDate2
        }
    }
}

// MARK: - Firebase Firestore

extension RecipeViewModel {
    /// きくらげ料理記録を読み込む
    public func loadRecipes(kikurageUserID: String) {
        let request = KikurageRecipeRequest(kikurageUserID: kikurageUserID)
        recipeRepository.getRecipes(request: request)
            .subscribe(
                onSuccess: { [weak self] recipes in
                    guard let `self` = self else {
                        return
                    }
                    let _recipes = self.sortRecipes(recipes: recipes)
                    self.subject.onNext(_recipes)
                },
                onFailure: { [weak self] error in
                    self?.errorSubject.onNext(error)
                }
            )
            .disposed(by: disposeBag)
    }
}
