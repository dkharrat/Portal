//
//  Example.swift
//  Example
//
//  Created by Guido Marucci Blas on 3/14/17.
//  Copyright © 2017 Guido Marucci Blas. All rights reserved.
//

import UIKit
import Portal

enum Message {

    case applicationStarted
    case replaceContent
    case goToRoot
    case routeChanged(to: Route)
    case increment
    case tick(Date)
    case ping(Date)
    case pong(String)
    case stateLoaded(State?)
    case segmentSelected(UInt)
    case changeColor
    case selectedItemChanged(UInt)
    case toggle(Bool)
    case search
    case searchComplete
    
}

enum Navigator: Equatable {

    case main
    case modal
    case other

}

enum Route: Portal.Route {

    case root
    case modal
    case detail
    case landscape
    case examples
    case verticalCollectionExample
    case labelExample
    case textViewExample
    case textFieldExample
    case imageExample
    case mapExample
    case progressExample
    case segmentedExample
    case spinnerExample
    case tableExample
    case carouselExample
    case horizontalCollectionExample
    
    var previous: Route? {
        switch self {
        case .root:
            return .none
        case .detail:
            return .root
        case .modal:
            return .root
        case .landscape:
            return .root
        case .examples:
            return .root
        case .verticalCollectionExample:
            return .examples
        case .labelExample:
            return .examples
        case .textViewExample:
            return .examples
        case .textFieldExample:
            return .examples
        case .imageExample:
            return .examples
        case .mapExample:
            return .examples
        case .progressExample:
            return .examples
        case .segmentedExample:
            return .examples
        case .spinnerExample:
            return .examples
        case .tableExample:
            return .examples
        case .carouselExample:
            return .examples
        case .horizontalCollectionExample:
            return .examples
        }
    }

}

enum State {

    case uninitialized
    case started(date: Date?, showAlert: Bool)
    case replacedContent
    case detailedScreen(counter: UInt)
    case modalScreen(counter: UInt)
    case landscapeScreen(text: String, counter: UInt)
    case examples
    case verticalCollectionExample(color: Color, searching: Bool, showFullName: Bool)
    case labelExample
    case textViewExample
    case textFieldExample
    case imageExample
    case mapExample
    case progressExample
    case segmentedExample(selected: UInt)
    case spinnerExample
    case tableExample(color: Color, searching: Bool, showFullName: Bool)
    case verticalCarouselExample(color: Color, selectedItem: UInt)
    case horizontalCollectionExample(color: Color)
}

final class ExampleApplication: Portal.Application {

    typealias Action = Portal.Action<Route, Message>
    typealias View = Portal.View<Route, Message, Navigator>
    typealias Subscription = Portal.Subscription<Message, Route, IgniteSubscription>

    var initialState: State { return .uninitialized }

    var initialRoute: Route { return .root }

    func translateRouteChange(from currentRoute: Route, to nextRoute: Route) -> Message? {
        print("Route change '\(currentRoute)' -> '\(nextRoute)'")
        return .routeChanged(to: nextRoute)
    }

    func update(state: State, message: Message) -> (State, Command?)? {
        print("---> Message: \(message)")
        switch (state, message) {

        case (.uninitialized, .applicationStarted):
            return (.started(date: .none, showAlert: false), .none)

        // MARK:- Started state transitions

        case (.started, .replaceContent):
            return (.replacedContent, .none)

        case (.started, .routeChanged(.modal)):
            return (.modalScreen(counter: 0), .none)

        case (.started, .routeChanged(.detail)):
            return (.detailedScreen(counter: 0), .none)

        case (.started, .routeChanged(.landscape)):
            return (.landscapeScreen(text: "Hello!", counter: 0), .none)

        case (.started, .tick(let date)):
            return (.started(date: date, showAlert: false), .none)

        case (.started(let date, _), .pong(let text)):
            print("PONG -> \(text)")
            return (.started(date: date, showAlert: true), .none)

        case (.started, .routeChanged(.examples)):
            return (.examples, .none)

        // MARK:- Replaced content state transitions

        case (.replacedContent, .goToRoot):
            return (.started(date: .none, showAlert: false), .none)

        // MARK:- Detailed screen state transitions

        case (.detailedScreen, .routeChanged(.root)):
            return (.started(date: .none, showAlert: false), .none)

        case (.detailedScreen(let counter), .increment):
            return (.detailedScreen(counter: counter + 1), .none)

        case (.detailedScreen(let counter), .ping(_)):
            return (.detailedScreen(counter: counter + 1), .none)

        case (.modalScreen, .routeChanged(.root)):
            return (.started(date: .none, showAlert: false), .none)

        // MARK:- Modal screen state transitions

        case (.modalScreen(let counter), .routeChanged(.detail)):
            return (.detailedScreen(counter: counter + 5), .none)

        case (.modalScreen(let count), .increment):
            return (.modalScreen(counter: count + 1), .none)

        case (.modalScreen, .routeChanged(.landscape)):
            return (.landscapeScreen(text: "Modal after modal!", counter: 0), .none)

        // MARK:- Landscape screen state transitions

        case (.landscapeScreen, .routeChanged(.root)):
            return (.started(date: .none, showAlert: false), .none)

        case (.landscapeScreen, .tick(_)):
            return (.landscapeScreen(text: "Tick tock!", counter: 0), .none)

        case (.landscapeScreen(let text, let count), .increment):
            return (.landscapeScreen(text: text, counter: count + 1), .none)

        // MARK:- Examples screen state transitions

        case (.examples, .routeChanged(.root)):
            return (.started(date: .none, showAlert: false), .none)

        case (.examples, .routeChanged(.verticalCollectionExample)):
            return (.verticalCollectionExample(color: .black, searching: false, showFullName: true), .none)

        case (.examples, .routeChanged(.horizontalCollectionExample)):
            return (.horizontalCollectionExample(color: .black), .none)
            
        case (.examples, .routeChanged(.labelExample)):
            return (.labelExample, .none)

        case (.examples, .routeChanged(.textViewExample)):
            return (.textViewExample, .none)

        case (.examples, .routeChanged(.textFieldExample)):
            return (.textFieldExample, .none)

        case (.examples, .routeChanged(.imageExample)):
            return (.imageExample, .none)

        case (.examples, .routeChanged(.mapExample)):
            return (.mapExample, .none)

        case (.examples, .routeChanged(.progressExample)):
            return (.progressExample, .none)

        case (.examples, .routeChanged(.segmentedExample)):
            return (.segmentedExample(selected: 3), .none)

        case (.examples, .routeChanged(.spinnerExample)):
            return (.spinnerExample, .none)

        case (.examples, .routeChanged(.tableExample)):
            return (.tableExample(color: .green, searching: false, showFullName: true), .none)

        case (.examples, .routeChanged(.carouselExample)):
            return (.verticalCarouselExample(color: .black, selectedItem: 0), .none)

        // MARK:- Vertical Collection example state transitions

        case (.verticalCollectionExample, .routeChanged(.examples)):
            return (.examples, .none)

        case (.verticalCollectionExample(.white, let searching, let showFullName), .changeColor):
            return (.verticalCollectionExample(color: .black, searching: searching, showFullName: showFullName), .none)

        case (.verticalCollectionExample(.black, let searching, let showFullName), .changeColor):
            return (.verticalCollectionExample(color: .white, searching: searching, showFullName: showFullName), .none)

        case (.verticalCollectionExample(let color, _, let showFullName), .search):
            return (.verticalCollectionExample(color: color, searching: true, showFullName: showFullName), .search)
            
        case (.verticalCollectionExample(let color, _, let showFullName), .searchComplete):
            return (.verticalCollectionExample(color: color, searching: false, showFullName: !showFullName), .none)
            
        // MARK:- Horizontal Collection example state transitions
            
        case (.horizontalCollectionExample, .routeChanged(.examples)):
            return (.examples, .none)
            
        case (.horizontalCollectionExample(.white), .changeColor):
            return (.horizontalCollectionExample(color: .black), .none)
            
        case (.horizontalCollectionExample(.black), .changeColor):
            return (.horizontalCollectionExample(color: .white), .none)
            
        // MARK:- Label example state transitions

        case (.labelExample, .routeChanged(.examples)):
            return (.examples, .none)

        // MARK:- TextView example state transitions

        case (.textViewExample, .routeChanged(.examples)):
            return (.examples, .none)

        // MARK:- TextField example state transitions

        case (.textFieldExample, .routeChanged(.examples)):
            return (.examples, .none)

        // MARK:- Image example state transitions

        case (.imageExample, .routeChanged(.examples)):
            return (.examples, .none)

        // MARK:- Map example state transitions

        case (.mapExample, .routeChanged(.examples)):
            return (.examples, .none)

        // MARK:- Progress example state transitions

        case (.progressExample, .routeChanged(.examples)):
            return (.examples, .none)

        // MARK:- Segment example state transitions

        case (.segmentedExample, .segmentSelected(let index)):
            return (.segmentedExample(selected: index), .none)

        case (.segmentedExample, .routeChanged(.examples)):
            return (.examples, .none)

        // MARK:- Spinner example state transitions

        case (.spinnerExample, .routeChanged(.examples)):
            return (.examples, .none)

        // MARK:- Table example state transitions

        case (.tableExample(.green, let searching, let showFullName), .changeColor):
            return (.tableExample(color: .red, searching: searching, showFullName: showFullName), .none)

        case (.tableExample(.red, let searching, let showFullName), .changeColor):
            return (.tableExample(color: .green, searching: searching, showFullName: showFullName), .none)

        case (.tableExample(let color, _, let showFullName), .search):
            return (.tableExample(color: color, searching: true, showFullName: showFullName), .search)
        
        case (.tableExample(let color, _, let showFullName), .searchComplete):
            return (.tableExample(color: color, searching: false, showFullName: !showFullName), .none)
            
        case (.tableExample, .routeChanged(.examples)):
            return (.examples, .none)

        // MARK:- Table example state transitions

        case (.verticalCarouselExample(.white, let index), .changeColor):
            return (.verticalCarouselExample(color: .black, selectedItem: index), .none)

        case (.verticalCarouselExample(.black, let index), .changeColor):
            return (.verticalCarouselExample(color: .white, selectedItem: index), .none)

        case (.verticalCarouselExample(let color, _), .selectedItemChanged(let index)):
            return (.verticalCarouselExample(color: color, selectedItem: index), .none)

        case (.verticalCarouselExample, .routeChanged(.examples)):
            return (.examples, .none)

        // MARK:- Miscelaneus state transitions

        case (_, .pong(let text)):
            print("PONG -> \(text)")
            return (state, .none)

        default:
            return .none

        }

    }

    func view(for state: State) -> View {
        switch state {

        case .started(_, true):
            return MainScreen.alert()

        case .started(let date, false):
            return MainScreen.mainView(date: date)

        case .replacedContent:
            return MainScreen.replacedContent()

        case .detailedScreen(let counter):
            return DetailScreen.view(counter: counter)

        case .modalScreen(let counter):
            return ModalScreen.view(counter: counter)

        case .landscapeScreen(let text, let count):
            return LandscapeScreen.view(text: text, count: count)

        case .examples:
            return ExamplesScreen.view()

        case .verticalCollectionExample(let color, let searching, let showFullName):
            return VerticalCollectionScreen.view(color: color, searching: searching, showFullName: showFullName)

        case .labelExample:
            return LabelScreen.view()

        case .textFieldExample:
            return TextFieldScreen.view()

        case .textViewExample:
            return TextViewScreen.view()

        case .imageExample:
            return ImageScreen.view()

        case .mapExample:
            return MapScreen.view()

        case .spinnerExample:
            return SpinnerScreen.view()

        case .progressExample:
            return ProgressScreen.view()

        case .segmentedExample(let index):
            return SegmentedScreen.view(selected: index)

        case .tableExample(let color, let searching, let showFullName):
            return TableScreen.view(color: color, searching: searching, showFullName: showFullName)

        case .verticalCarouselExample(let color, let index):
            return CarouselScreen.view(color: color, selectedItem: index)
        
        case .horizontalCollectionExample(color: let color):
            return HorizontalCollectionScreen.view(color: color)
            
        default:
            return DefaultScreen.view()
        }
    }

    func subscriptions(for state: State) -> [Subscription] {
        switch state {
        case .started:
            return [
                .timer(.only(fire: 3, every: 1, unit: .second, tag: "Main timer") { .sendMessage(.tick($0)) })
            ]
        case .detailedScreen:
            return [
                .timer(.only(fire: 3, every: 1, unit: .second, tag: "Main timer") { .sendMessage(.tick($0)) }),
                .timer(.only(fire: 10, every: 1, unit: .second, tag: "Detail timer") { .sendMessage(.ping($0)) })
            ]
        case .landscapeScreen:
            return [
                .timer(.only(fire: 1, every: 1, unit: .millisecond, tag: "Landscape timer") { .sendMessage(.tick($0)) })
            ]
        case .modalScreen:
            return [
                .timer(.only(fire: 5, every: 1, unit: .second, tag: "Modal timer") { _ in .sendMessage(.increment) })
            ]
        default:
            return []
        }
    }

}
