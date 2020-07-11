//
//  TimelineView.swift
//  NetNewsWire
//
//  Created by Maurice Parker on 6/30/20.
//  Copyright © 2020 Ranchero Software. All rights reserved.
//

import SwiftUI

struct TimelineView: View {
	
	@EnvironmentObject private var timelineModel: TimelineModel
	@State var navigate = false

	@ViewBuilder var body: some View {
		#if os(macOS)
		ZStack {
			NavigationLink(destination: ArticleContainerView(articles: timelineModel.selectedArticles), isActive: $navigate) {
				EmptyView()
			}.hidden()
			List(timelineModel.timelineItems, selection: $timelineModel.selectedArticleIDs) { timelineItem in
				buildTimelineItemNavigation(timelineItem)
			}
		}
		.onChange(of: timelineModel.selectedArticleIDs) { value in
			navigate = !timelineModel.selectedArticleIDs.isEmpty
		}
		#else
		List(timelineModel.timelineItems) { timelineItem in
			buildTimelineItemNavigation(timelineItem)
		}
		#endif
    }

	func buildTimelineItemNavigation(_ timelineItem: TimelineItem) -> some View {
		#if os(macOS)
		return TimelineItemView(timelineItem: timelineItem)
		#else
		return ZStack {
			TimelineItemView(timelineItem: timelineItem)
			NavigationLink(destination: ArticleContainerView(articles: timelineModel.selectedArticles),
						   tag: timelineItem.article.articleID,
						   selection: $timelineModel.selectedArticleID) {
				EmptyView()
			}.buttonStyle(PlainButtonStyle())
		}
		#endif
	}
	
}
