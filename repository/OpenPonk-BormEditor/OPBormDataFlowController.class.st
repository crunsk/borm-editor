Class {
	#name : #OPBormDataFlowController,
	#superclass : #OPBormElementController,
	#instVars : [
		'labelFigure',
		'iconFigure'
	],
	#category : #'OpenPonk-BormEditor-Controllers'
}

{ #category : #'as yet unclassified' }
OPBormDataFlowController >> buildEditorForm: aForm [
	super buildEditorForm: aForm.

	(aForm addDroplist: 'Type')
		items: #(#input #output);
		displayBlock: [ :type | type asString ];
		setSelectedItem: self model type;
		whenSelectedItemChanged: [ :newValue | self model type: newValue ]
]

{ #category : #testing }
OPBormDataFlowController >> canVisitTarget: aController [
	^ aController canBeTargetForDataFlow: self
]

{ #category : #private }
OPBormDataFlowController >> constraintOnEdge: anElement [
	| edge cb const |
	edge := (self diagramController controllerForModel: model owner) figure.
	const := OPRTRailConstraint new.
	const
		initialPosition: 0.5;
		distance: 10.
	const element: anElement connection: edge.

	cb := TRTranslationCallback block: [ self refreshIcon ].
	edge from addCallback: cb.
	edge to addCallback: cb.
	anElement
		addCallback:
			(TRRemoveCallback
				block:
					[ 
					edge from trachelShape removeCallback: cb ifAbsent: [ self error ].
					edge to trachelShape removeCallback: cb ifAbsent: [ self error ] ])
]

{ #category : #private }
OPBormDataFlowController >> createContainerShape [
	^ RTRoundedBox new
		width: 40;
		height: 35;
		color: Color transparent;
		borderColor: Color gray;
		borderWidth: 0.5
]

{ #category : #hooks }
OPBormDataFlowController >> createFigure [
	^ OPRTCallbackBuilder block: [ :view | self createFigureInView: view ]
]

{ #category : #private }
OPBormDataFlowController >> createFigureInView: aView [
	| container |
	container := self createContainerShape element.
	container @ RTDraggable.

	labelFigure := (RTLabel new
		height: 10;
		color: Color black) elementOn: ''.
	(RTConstraint on: labelFigure background: container)
		top;
		stick.

	iconFigure := (RTBitmap new form: OPBormEditorIcons current dataFlowLeftIcon) element.
	(RTConstraint on: iconFigure background: container trachelShape)
		bottom;
		padding: 5;
		stick.

	container addCallback: (TRRemoveCallback with: iconFigure with: labelFigure).

	aView
		add: container;
		add: iconFigure;
		add: labelFigure.

	self constraintOnEdge: container.
	
	self saveStateOnDragEndFor: container.

	^ container
]

{ #category : #accessing }
OPBormDataFlowController >> modelClass [
	^ BormDataFlow
]

{ #category : #hooks }
OPBormDataFlowController >> refreshFigure [
	labelFigure trachelShape text: self model name.
	figure width: (labelFigure width max: 40).
	self refreshIcon.
	self diagramController view signalUpdate.
]

{ #category : #'as yet unclassified' }
OPBormDataFlowController >> refreshIcon [
	| edge right |
	edge := (self diagramController controllerForModel: model owner) figure.
	right := edge from position x < edge to position x.
	self model isOutput
		ifTrue: [ right := right not ].
	right
		ifTrue: [ iconFigure trachelShape form: OPBormEditorIcons current dataFlowRightIcon ]
		ifFalse: [ iconFigure trachelShape form: OPBormEditorIcons current dataFlowLeftIcon ]
]

{ #category : #destruction }
OPBormDataFlowController >> removeModel [
	self model owner remove: self model
]

{ #category : #private }
OPBormDataFlowController >> renderFigureIn: aView [
	figure := self createContainerShape element.
	figure @ RTDraggable.
	labelFigure := (RTLabel new
		height: 10;
		color: Color black) elementOn: ''.
	(RTConstraint on: labelFigure background: figure)
		top;
		stick.
	iconFigure := (RTBitmap new
		form: OPBormEditorIcons current dataFlowLeftIcon) element.
	(RTConstraint on: iconFigure background: figure trachelShape)
		bottom;
		padding: 5;
		stick.
	figure
		addCallback: (TRRemoveCallback with: iconFigure with: labelFigure).
	aView
		add: figure;
		add: iconFigure;
		add: labelFigure.
	self constraintOnEdge: figure.
	self saveStateOnDragEndFor: figure.
	^ figure
]

{ #category : #visiting }
OPBormDataFlowController >> visitTarget: aController [
	^ aController addAsTargetForDataFlow: self
]