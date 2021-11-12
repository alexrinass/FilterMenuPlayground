//
//  RefsLoader.swift
//  FilterMenuPlayground
//
//  Created by Alexander Rinass on 15.11.21.
//

import Foundation

class RefsLoader {
    var allRefs = [
        "feature/allow-empty-commit",
        "feature/auto-relocate-repository",
        "feature/autosquash-refactoring",
        "feature/bitbucket-api-changes",
        "feature/branches-view",
        "feature/branches-view-cache",
        "feature/build-tools-refactoring",
        "feature/code-stats-rake-task",
        "feature/dark-mode-bgcolor-fixes",
        "feature/dashboard",
        "feature/dashboard-empty-view",
        "feature/developer-plugin",
        "feature/diff-improvements",
        "feature/diff-inline-highlighting",
        "feature/fix-rake-on-apple-silicon",
        "feature/force-with-lease",
        "feature/high-cpu-usage-fix",
        "feature/improve-gpg-verification",
        "feature/improve-tags-updating",
        "feature/markdown",
        "feature/push-revision-options",
        "feature/registration-dialogue-improvements",
        "feature/remove-blocking-operations",
        "feature/remove-column-resize",
        "feature/repository-sidebar-refactoring",
        "feature/segmented-toolbar",
        "feature/services-authentication-methods",
        "feature/terminal-app-refactoring",
        "feature/toolbar-alignment-1066",
        "feature/undo-worktree-snapshot-refactoring",
        "feature/xcode-13",
        "high-cpu-fix-old-fullsize",
        "main",
        "next",
        "next-old",
        "v2/end-of-life",
        "v2/master",
        "wip/alex/head-branch-toolbar-item",
        "wip/peter/filter-menu"
    ]
    var refs: [String] = []
    var filterString: String?

    func reload() {
        if let filterString = filterString {
            if filterString.count > 0 {
                refs = allRefs.filter { $0.contains(filterString) }
                return
            }
        }

        refs = allRefs
    }
}
