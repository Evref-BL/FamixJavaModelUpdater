Trait {
	#name : 'TFJMUEntityFactory',
	#instVars : [
		'famixModel',
		'fileAnchorPath',
		'fastModel',
		'newStartPosition',
		'newEndPosition'
	],
	#category : 'FamixJavaModelUpdater-Updater',
	#package : 'FamixJavaModelUpdater',
	#tag : 'Updater'
}

{ #category : 'model - create' }
TFJMUEntityFactory >> create: aFamixClass [

	^ self famixModel add: aFamixClass new
]

{ #category : 'model - create' }
TFJMUEntityFactory >> create: aFamixClass from: aFastJavaEntity [

	| entity |
	entity := self create: aFamixClass.
	self fileAnchorPath ifNotNil: [ :famixSourceAnchor |
		entity sourceAnchor:
			(self generateAnchorBasedOn: famixSourceAnchor for: aFastJavaEntity) ].
	^ entity
]

{ #category : 'accessing' }
TFJMUEntityFactory >> famixModel [

	^ famixModel
]

{ #category : 'accessing' }
TFJMUEntityFactory >> famixModel: anObject [

	famixModel := anObject
]

{ #category : 'accessing' }
TFJMUEntityFactory >> fastModel [

	^ fastModel
]

{ #category : 'accessing' }
TFJMUEntityFactory >> fastModel: anObject [

	fastModel := anObject
]

{ #category : 'accessing' }
TFJMUEntityFactory >> fastScopeOwnerOf: aFASTJavaNode [

	^ (aFASTJavaNode atAnyScope: { 
			   FASTJavaMethodEntity.
			   FASTJavaClassDeclaration }) ifNotNil: [ :scopes | scopes anyOne ]
]

{ #category : 'accessing' }
TFJMUEntityFactory >> fileAnchorPath [

	^ fileAnchorPath
]

{ #category : 'accessing' }
TFJMUEntityFactory >> fileAnchorPath: anObject [

	fileAnchorPath := anObject
]

{ #category : 'model - create' }
TFJMUEntityFactory >> generateAnchorBasedOn: famixSourceAnchor for: aFastJavaEntity [

	| safeStart safeEnd |
	safeStart := self newStartPosition ifNil: [ aFastJavaEntity startPos ].

	safeEnd := self newEndPosition ifNil: [ aFastJavaEntity endPos ].
	
	^ (self create: FamixJavaIndexedFileAnchor)
		  startPos: safeStart;
		  endPos: safeEnd;
		  fileName: famixSourceAnchor;
		  yourself

	"^ (self create: PLSDocument)
		  text: (aFastJavaEntity sourceText copyFrom: safeStart to: safeEnd);
		  uri: famixSourceAnchor;
		  yourself"
]

{ #category : 'accessing' }
TFJMUEntityFactory >> newEndPosition [

	^ newEndPosition
]

{ #category : 'accessing' }
TFJMUEntityFactory >> newEndPosition: anObject [

	newEndPosition := anObject
]

{ #category : 'accessing' }
TFJMUEntityFactory >> newStartPosition [

	^ newStartPosition
]

{ #category : 'accessing' }
TFJMUEntityFactory >> newStartPosition: anObject [

	newStartPosition := anObject
]

{ #category : 'model - create' }
TFJMUEntityFactory >> retrieveClassFromModel: aClassName [

	^ (fastModel allWithType: FASTJavaImportDeclaration)
		  detect: [ :importDeclaration | 
			  importDeclaration declarationName name = aClassName ]
		  ifOne: [ :importDeclaration | 
			  self famixModel allPackages
				  detect: [ :pa | 
					  pa qualifiedName
					  = importDeclaration declarationName namespace fullName ]
				  ifOne: [ :package | 
					  package types
						  detect: [ :type | type name = aClassName ]
						  ifNone: [ nil ] ] ]
		  ifNone: [ 
			  self famixModel allModelTypes  asOrderedCollection
				  detect: [ :class | class name = aClassName ]
				  ifNone: [ nil ] ]
]
