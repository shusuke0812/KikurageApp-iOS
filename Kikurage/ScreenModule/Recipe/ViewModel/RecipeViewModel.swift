//
//  RecipeViewModel.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2020/12/27.
//  Copyright © 2020 shusuke. All rights reserved.
//

import UIKit.UITableView
import RxSwift
import RxRelay

protocol RecipeViewModelInput {
    var itemSelected: AnyObserver<IndexPath> { get }
}

protocol RecipeViewModelOutput {
    var recipes: Observable<[KikurageRecipeTuple]> { get }
    var recipe: Observable<KikurageRecipeTuple> { get }
}

protocol RecipeViewModelType {
    var input: RecipeViewModelInput { get }
    var output: RecipeViewModelOutput { get }
}

class RecipeViewModel: RecipeViewModelType, RecipeViewModelInput, RecipeViewModelOutput {
    private let recipeRepository: RecipeRepositoryProtocol

    private let disposeBag = RxSwift.DisposeBag()
    private let subject = PublishSubject<[KikurageRecipeTuple]>()

    var input: RecipeViewModelInput { self }
    var output: RecipeViewModelOutput { self }

    var itemSelected: AnyObserver<IndexPath>

    var recipes: Observable<[KikurageRecipeTuple]> { subject.asObservable() }
    var recipe: Observable<KikurageRecipeTuple>

    init(recipeRepository: RecipeRepositoryProtocol) {
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
            guard let recipeDate1 = DateHelper.formatToDate(dateString: recipe1.data.cookDate) else { return false }
            guard let recipeDate2 = DateHelper.formatToDate(dateString: recipe2.data.cookDate) else { return false }
            return recipeDate1 > recipeDate2
        }
    }
}

// MARK: - Firebase Firestore

extension RecipeViewModel {
    /// きくらげ料理記録を読み込む
    func loadRecipes(kikurageUserId: String) {
        let request = KikurageRecipeRequest(kikurageUserId: kikurageUserId)
        recipeRepository.getRecipes(request: request)
            .subscribe(
                onSuccess: { [weak self] recipes in
                    guard let `self` = self else { return }
                    let recipes = self.sortRecipes(recipes: recipes)
                    self.subject.onNext(recipes)
                },
                onFailure: { [weak self] error in
                    self?.subject.onError(error)
                }
            )
            .disposed(by: disposeBag)
    }
}
