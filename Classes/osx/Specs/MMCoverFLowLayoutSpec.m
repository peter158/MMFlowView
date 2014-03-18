/*
 
 The MIT License (MIT)
 
 Copyright (c) 2014 Markus Müller https://github.com/mmllr All rights reserved.
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this
 software and associated documentation files (the "Software"), to deal in the Software
 without restriction, including without limitation the rights to use, copy, modify, merge,
 publish, distribute, sublicense, and/or sell copies of the Software, and to permit
 persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies
 or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
 INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
 PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
 FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
 OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 DEALINGS IN THE SOFTWARE.
 
 */
//
//  MMCoverFLowLayoutSpec.m
//  MMFlowViewDemo
//
//  Created by Markus Müller on 18.10.13.
//  Copyright 2013 www.isnotnil.com. All rights reserved.
//

#import "Kiwi.h"
#import "MMCoverFLowLayout.h"
#import "MMCoverFlowLayoutAttributes.h"

#define DEGREES2RADIANS(angleInDegrees) ((angleInDegrees) * M_PI / 180.)

SPEC_BEGIN(MMCoverFLowLayoutSpec)

describe(@"MMCoverFlowLayout", ^{
	__block MMCoverFlowLayout *sut = nil;

	context(@"designated initalizer", ^{
		context(@"too small value for contentHeight", ^{
			beforeEach(^{
				sut = [[MMCoverFlowLayout alloc] initWithContentHeight:-100];
			});
			it(@"should have a contentHeight of 1", ^{
				[[theValue(sut.contentHeight) should] equal:theValue(1)];
			});
		});
		beforeEach(^{
			sut = [[MMCoverFlowLayout alloc] initWithContentHeight:200];
		});
		it(@"should set the contentHeight", ^{
			[[theValue(sut.contentHeight) should] equal:theValue(200)];
		});
	});
	context(@"a new instance", ^{
		beforeEach(^{
			sut = [[MMCoverFlowLayout alloc] init];
		});
		afterEach(^{
			sut = nil;
		});
		it(@"should exist", ^{
			[[sut shouldNot] beNil];
		});
		it(@"should respond to initWithCoder:", ^{
			[[sut should] respondToSelector:@selector(initWithCoder:)];
		});
		it(@"should respond to encodeWithCoder:", ^{
			[[sut should] respondToSelector:@selector(encodeWithCoder:)];
		});
		it(@"should have the default inter item spacing of 10", ^{
			[[theValue(sut.interItemSpacing) should] equal:theValue(10)];
		});
		it(@"should have a default stacked angle of 70", ^{
			[[theValue(sut.stackedAngle) should] equal:theValue(70)];
		});
		it(@"should have a default selected index of NSNotFound", ^{
			[[theValue(sut.selectedItemIndex) should] equal:theValue(NSNotFound)];
		});
		it(@"should have an item count of 0", ^{
			[[theValue(sut.numberOfItems) should] equal:theValue(0)];
		});
		it(@"should have a default vertical margin of 10", ^{
			[[theValue(sut.verticalMargin) should] equal:theValue(10)];
		});
		it(@"should have a zero contentWidth", ^{
			[[theValue(sut.contentWidth) should] equal:theValue(0)];
		});
		it(@"should have a default contentHeight of 100", ^{
			[[theValue(sut.contentHeight) should] equal:theValue(100)];
		});
		it(@"should have a default stackedDistance of 300", ^{
			[[theValue(sut.stackedDistance) should] equal:theValue(300)];
		});
		it(@"should return nil for layoutAttributesForItemAtIndex", ^{
			[[[sut layoutAttributesForItemAtIndex:0] should] beNil];
		});
		context(@"itemSize", ^{
			__block CGFloat expectedHeight;
			beforeEach(^{
				expectedHeight = sut.contentHeight - sut.verticalMargin * 2;
			});
			it(@"should have an itemHeight of contentHeight minus two times verticalMargin", ^{
				
				[[theValue(sut.itemSize.height) should] equal:theValue(expectedHeight)];
			});
			it(@"should have a square item size", ^{
				[[theValue(sut.itemSize.width) should] equal:theValue(sut.itemSize.height)];
			});
		});
		context(@"contentHeight", ^{
			it(@"should not be smaller than 1", ^{
				sut.contentHeight = 0;
				[[theValue(sut.contentHeight) shouldNot] beLessThan:theValue(1)];
			});
		});
		context(@"verticalMargin", ^{
			it(@"should not be less than 0", ^{
				sut.verticalMargin = -10;
				[[theValue(sut.verticalMargin) shouldNot] beLessThan:theValue(0)];
			});
			it(@"should not be greater than the contentHeight", ^{
				sut.verticalMargin = sut.contentHeight * 2;
				[[theValue(sut.verticalMargin) shouldNot] beGreaterThan:theValue(sut.contentHeight)];
			});
		});
		context(@"interItemSpacing", ^{
			it(@"should not set negative values", ^{
				sut.interItemSpacing = -10;
				[[theValue(sut.interItemSpacing) should] beGreaterThan:theValue(0)];
			});
			it(@"should set the minimum value of 1", ^{
				sut.interItemSpacing = 1.f;
				[[theValue(sut.interItemSpacing) should] equal:theValue(1)];
			});
		});
		context(@"stackedAngle", ^{
			it(@"it should set the minimum of 0 for a negative angle", ^{
				sut.stackedAngle = -10;
				[[theValue(sut.stackedAngle) should] equal:theValue(0)];
			});
			it(@"should set the minimum allowed value of 0", ^{
				sut.stackedAngle = 0;
				[[theValue(sut.stackedAngle) should] equal:theValue(0)];
			});
			it(@"should set the maximum value of 90", ^{
				sut.stackedAngle = 90;
				[[theValue(sut.stackedAngle) should] equal:theValue(90)];
			});
			it(@"it should set the maximum of 90 for an angle greater than 90", ^{
				sut.stackedAngle = 100;
				[[theValue(sut.stackedAngle) should] equal:theValue(90)];
			});
		});
		context(@"selectedIndex", ^{
			it(@"should not set the seletion with no items", ^{
				sut.selectedItemIndex = 0;
				[[theValue(sut.selectedItemIndex) should] equal:theValue(NSNotFound)];
			});
		});
		context(@"stackedDistance", ^{
			it(@"should not set negative values", ^{
				sut.stackedDistance = -100;
				[[theValue(sut.stackedDistance) should] beGreaterThanOrEqualTo:theValue(0)];
			});
		});
		context(@"many items (10)", ^{
			beforeEach(^{
				sut.numberOfItems = 10;
			});
			afterEach(^{
				sut.numberOfItems = 0;
			});
			context(@"no previously selected item", ^{
				it(@"should select the first item", ^{
					[[theValue(sut.selectedItemIndex) should] equal:theValue(0)];
				});
			});
			it(@"should set the number of items", ^{
				[[theValue(sut.numberOfItems) should] equal:theValue(10)];
			});
			context(@"selecting items", ^{
				context(@"any item in bounds", ^{
					__block NSUInteger expectedIndex;
	
					beforeEach(^{
						expectedIndex = arc4random_uniform((int32_t)sut.numberOfItems);
						sut.selectedItemIndex = expectedIndex;
					});
					it(@"should set the item", ^{
						[[theValue(sut.selectedItemIndex) should] equal:theValue(expectedIndex)];
					});
				});
				context(@"last item", ^{
					beforeEach(^{
						sut.selectedItemIndex = sut.numberOfItems - 1;
					});
					it(@"should select the last item", ^{
						[[theValue(sut.selectedItemIndex) should] equal:theValue(9)];
					});
					it(@"should select the first item", ^{
						sut.selectedItemIndex = 0;
						[[theValue(sut.selectedItemIndex) should] equal:theValue(0)];
					});
				});
				context(@"selecting beyound bounds", ^{
					beforeEach(^{
						sut.selectedItemIndex = sut.numberOfItems + 10;
					});
					it(@"should select the last index if asked to select beyound item count", ^{
						[[theValue(sut.selectedItemIndex) should] equal:theValue(9)];
					});
				});
				context(@"selecting NSNotFound", ^{
					__block NSUInteger previousSelection;
					
					beforeEach(^{
						previousSelection = sut.selectedItemIndex;
						sut.selectedItemIndex = NSNotFound;
					});
					it(@"should not select NSNotFound", ^{
						[[theValue(sut.selectedItemIndex) shouldNot] equal:theValue(NSNotFound)];
					});
					it(@"should keep the previously selected index", ^{
						[[theValue(sut.selectedItemIndex) should] equal:theValue(previousSelection)];
					});
				});
			});
			context(@"remove all items", ^{
				beforeEach(^{
					sut.numberOfItems = 0;
				});
				it(@"should set numberOfItems to 0", ^{
					[[theValue(sut.numberOfItems) should] equal:theValue(0)];
				});
				it(@"should have a selection of NSNotFound", ^{
					[[theValue(sut.selectedItemIndex) should] equal:theValue(NSNotFound)];
				});
			});
			context(@"invalid number of items", ^{
				__block NSUInteger expectedSelection;
				beforeEach(^{
					expectedSelection = sut.selectedItemIndex;
					sut.numberOfItems = NSNotFound;
				});
				it(@"it should not set NSNotFound for numberOfItems", ^{
					[[theValue(sut.numberOfItems) shouldNot] equal:theValue(NSNotFound)];
				});
				it(@"should not change the selection", ^{
					[[theValue(sut.selectedItemIndex) should] equal:theValue(expectedSelection)];
				});
			});
			context(@"layout attributes", ^{
				__block MMCoverFlowLayoutAttributes *attributes = nil;
				__block CGFloat expectedStackedItemWidth = 0;

				beforeEach(^{
					sut.selectedItemIndex = sut.numberOfItems / 2;
					attributes = [sut layoutAttributesForItemAtIndex:sut.selectedItemIndex];
					expectedStackedItemWidth = cos(DEGREES2RADIANS(sut.stackedAngle))*sut.itemSize.width + sut.interItemSpacing;
				});
				afterEach(^{
					attributes = nil;
				});
				it(@"should have the items vertically centered", ^{
					CGFloat expectecY = sut.contentHeight / 2 - sut.itemSize.height / 2;
					[[theValue(attributes.position.y) should] equal:theValue(expectecY)];
				});
				context(@"contentWidth", ^{
					__block CGFloat expectedContentWidth;
					
					context(@"selection on both ends of stack", ^{
						beforeEach(^{
							CGFloat stackedWidth = cos(DEGREES2RADIANS(sut.stackedAngle))*sut.itemSize.width + sut.interItemSpacing;
							expectedContentWidth = sut.itemSize.width + stackedWidth * (sut.numberOfItems-1) + sut.itemSize.width;
						});
						context(@"first item selected", ^{
							beforeEach(^{
								sut.selectedItemIndex = 0;
							});
							it(@"should habe a contentWidth of stackedWidth * number of stacked items plus item width plus one interItemSpacing", ^{
								[[theValue(sut.contentWidth) should] equal:theValue(expectedContentWidth)];
							});
						});
						context(@"last item selected", ^{
							beforeEach(^{
								sut.selectedItemIndex = sut.numberOfItems - 1;
							});
							it(@"should have a contentWidth of stackedWidth * number of stacked items plus item width plus one interItemSpacing", ^{
								[[theValue(sut.contentWidth) should] equal:theValue(expectedContentWidth)];
							});
						});
					});
					context(@"selection in stack", ^{
						it(@", should habe a contentWidth of stackedWidth * number of stacked items plus item width plus two interItemSpacing", ^{
							CGFloat stackedWidth = cos(DEGREES2RADIANS(sut.stackedAngle))*sut.itemSize.width + sut.interItemSpacing;
							expectedContentWidth = sut.itemSize.width + stackedWidth * (sut.numberOfItems - 1) + sut.itemSize.width * 2;
							[[theValue(sut.contentWidth) should] equal:theValue(expectedContentWidth)];
						});
					});
				});
				context(@"index bound checking", ^{
					it(@"should return attributes for first item", ^{
						[[[sut layoutAttributesForItemAtIndex:0] shouldNot] beNil];
					});
					it(@"should return attributes for last item", ^{
						[[[sut layoutAttributesForItemAtIndex:sut.numberOfItems - 1] shouldNot] beNil];
					});
					it(@"should return nil when asking for attributes outside bounds", ^{
						[[[sut layoutAttributesForItemAtIndex:sut.numberOfItems + 1] should] beNil];
					});
				});
				context(@"item size", ^{
					__block CGFloat expectedHeight;
					beforeEach(^{
						expectedHeight = sut.contentHeight - sut.verticalMargin*2;
					});
					it(@"should have a height of contentHeight - verticalMargin", ^{
						[[theValue(CGRectGetHeight(attributes.bounds)) should] equal:theValue(expectedHeight)];
					});
					it(@"should have same width as height", ^{
						[[theValue(CGRectGetWidth(attributes.bounds)) should] equal:theValue(CGRectGetHeight(attributes.bounds))];
					});
				});
				context(@"left stack", ^{
					afterEach(^{
						attributes = nil;
					});
					context(@"first item", ^{
						beforeEach(^{
							attributes = [sut layoutAttributesForItemAtIndex:0];
						});
						it(@"should have the left stack transform", ^{
							NSValue *expectedTransfrom = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(DEGREES2RADIANS(sut.stackedAngle), 0, 1, 0)];
							NSValue *actualTransform = [NSValue valueWithCATransform3D:attributes.transform];
							
							[[actualTransform should] equal:expectedTransfrom];
						});
						it(@"should have the correct index", ^{
							[[theValue(attributes.index) should] beZero];
						});
						it(@"should have an anchorPoint of {0.5, 0}", ^{
							NSValue *expectedPoint = [NSValue valueWithPoint:CGPointMake(.5, 0)];
							[[[NSValue valueWithPoint:attributes.anchorPoint] should] equal:expectedPoint];
						});
						it(@"should have a x position of zero", ^{
							[[theValue(attributes.position.x) should] beZero];
						});
						it(@"should have the items vertically centered", ^{
							CGFloat expectedY = sut.contentHeight / 2 - sut.itemSize.height / 2;
							[[theValue(attributes.position.y) should] equal:theValue(expectedY)];
						});
						it(@"should have zPosition of negative stackedDistance", ^{
							[[theValue(attributes.zPosition) should] equal:theValue(-sut.stackedDistance)];
						});
						it(@"should have a distance of cos(stackedAngle*itemWidth) plus interItemSpacing to its neighbor", ^{
							MMCoverFlowLayoutAttributes *nextItemAttributes = [sut layoutAttributesForItemAtIndex:attributes.index+1];
							CGFloat distance = nextItemAttributes.position.x - attributes.position.x;
							[[theValue(distance) should] equal:expectedStackedItemWidth withDelta:0.000001];
						});
					});
					context(@"left item before the selected item", ^{
						beforeEach(^{
							attributes = [sut layoutAttributesForItemAtIndex:sut.selectedItemIndex - 1];
						});
						it(@"should have the left stack transform", ^{
							NSValue *expectedTransfrom = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(DEGREES2RADIANS(sut.stackedAngle), 0, 1, 0)];
							NSValue *actualTransform = [NSValue valueWithCATransform3D:attributes.transform];
							
							[[actualTransform should] equal:expectedTransfrom];
						});
						it(@"should have the correct index", ^{
							[[theValue(attributes.index) should] equal:theValue(sut.selectedItemIndex - 1)];
						});
						it(@"should have an anchorPoint of {0.5, 0}", ^{
							NSValue *expectedPoint = [NSValue valueWithPoint:CGPointMake(.5, 0)];
							[[[NSValue valueWithPoint:attributes.anchorPoint] should] equal:expectedPoint];
						});
						it(@"should have the x position of itemIndex * expectedStackedItemWidth", ^{
							CGFloat expectedX = expectedStackedItemWidth * attributes.index;
							[[theValue(attributes.position.x) should] equal:expectedX withDelta:0.00000001];
						});
						it(@"should have the items vertically centered", ^{
							CGFloat expectedY = sut.contentHeight / 2 - sut.itemSize.height / 2;
							[[theValue(attributes.position.y) should] equal:theValue(expectedY)];
						});
						it(@"should have zPosition of negative stackedDistance", ^{
							[[theValue(attributes.zPosition) should] equal:theValue(-sut.stackedDistance)];
						});
					});
				});
				context(@"selected item", ^{
					beforeEach(^{
						attributes = [sut layoutAttributesForItemAtIndex:sut.selectedItemIndex];
					});
					afterEach(^{
						attributes = nil;
					});
					it(@"should have an identity transform", ^{
						NSValue *expectedTransfrom = [NSValue valueWithCATransform3D:CATransform3DIdentity];
						[[[NSValue valueWithCATransform3D:attributes.transform] should] equal:expectedTransfrom];
					});
					it(@"should have the correct index", ^{
						[[theValue(attributes.index) should] equal:theValue(sut.selectedItemIndex)];
					});
					it(@"should have an anchorPoint of {0.5, 0}", ^{
						NSValue *expectedPoint = [NSValue valueWithPoint:CGPointMake(.5, 0)];
						[[[NSValue valueWithPoint:attributes.anchorPoint] should] equal:expectedPoint];
					});
					it(@"should have a zPosition of zero", ^{
						[[theValue(attributes.zPosition) should] beZero];
					});
					it(@"should have the x position of itemIndex*expectedStackedItemWidth plus an itemWidth if the first item is not selected", ^{
						CGFloat expectedX = expectedStackedItemWidth * sut.selectedItemIndex + sut.itemSize.width;
						[[theValue(attributes.position.x) should] equal:expectedX withDelta:0.0000001];
					});
					context(@"first item selected", ^{
						beforeEach(^{
							sut.selectedItemIndex = 0;
							attributes = [sut layoutAttributesForItemAtIndex:sut.selectedItemIndex];
						});
						it(@"should have the x position of zero", ^{
							[[theValue(attributes.position.x) should] beZero];
						});
					});
				});
				context(@"right stack", ^{
					afterEach(^{
						attributes = nil;
					});
					context(@"item right from selected item", ^{
						beforeEach(^{
							attributes = [sut layoutAttributesForItemAtIndex:sut.selectedItemIndex + 1];
						});
						it(@"should have the right stack transform", ^{
							NSValue *expectedTransfrom = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(-DEGREES2RADIANS(sut.stackedAngle), 0, 1, 0)];
							
							[[[NSValue valueWithCATransform3D:attributes.transform] should] equal:expectedTransfrom];
						});
						it(@"should have the correct index", ^{
							[[theValue(attributes.index) should] equal:theValue(sut.selectedItemIndex + 1)];
						});
						it(@"should have an anchorPoint of {0.5, 0}", ^{
							NSValue *expectedPoint = [NSValue valueWithPoint:CGPointMake(.5, 0)];
							[[[NSValue valueWithPoint:attributes.anchorPoint] should] equal:expectedPoint];
						});
						it(@"should have zPosition of negative stackedDistance", ^{
							[[theValue(attributes.zPosition) should] equal:theValue(-sut.stackedDistance)];
						});
						it(@"should have the x position of itemIndex*expectedStackedItemWidth plus two times the item width if the first item is not selected", ^{
							CGFloat expectedX = expectedStackedItemWidth*attributes.index + sut.itemSize.width*2;
							[[theValue(attributes.position.x) should] equal:expectedX withDelta:0.00000001];
						});
						it(@"should have the items vertically centered", ^{
							CGFloat expectedY = sut.contentHeight / 2 - sut.itemSize.height / 2;
							[[theValue(attributes.position.y) should] equal:theValue(expectedY)];
						});
					});
					context(@"last item", ^{
						beforeEach(^{
							attributes = [sut layoutAttributesForItemAtIndex:sut.numberOfItems-1];
						});
						it(@"should have the right stack transform", ^{
							NSValue *expectedTransfrom = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(-DEGREES2RADIANS(sut.stackedAngle), 0, 1, 0)];
							
							[[[NSValue valueWithCATransform3D:attributes.transform] should] equal:expectedTransfrom];
						});
						it(@"should have the correct index", ^{
							[[theValue(attributes.index) should] equal:theValue(sut.numberOfItems-1)];
						});
						it(@"should have an anchorPoint of {0.5, 0}", ^{
							NSValue *expectedPoint = [NSValue valueWithPoint:CGPointMake(.5, 0)];
							[[[NSValue valueWithPoint:attributes.anchorPoint] should] equal:expectedPoint];
						});
						it(@"should have zPosition of negative stackedDistance", ^{
							[[theValue(attributes.zPosition) should] equal:theValue(-sut.stackedDistance)];
						});
						it(@"should have the x position of itemIndex*expectedStackedItemWidth plus two times the item width if the first item is not selected", ^{
							CGFloat expectedX = expectedStackedItemWidth*attributes.index + sut.itemSize.width*2;
							[[theValue(attributes.position.x) should] equal:expectedX withDelta:0.0000001];
						});
						it(@"should have the items vertically centered", ^{
							CGFloat expectedY = sut.contentHeight / 2 - sut.itemSize.height / 2;
							[[theValue(attributes.position.y) should] equal:theValue(expectedY)];
						});
					});
					context(@"first item selected", ^{
						beforeEach(^{
							sut.selectedItemIndex = 0;
							attributes = [sut layoutAttributesForItemAtIndex:sut.selectedItemIndex + 1];
						});
						it(@"should have the x position of itemIndex*expectedStackedItemWidth plus one item width", ^{
							CGFloat expectedX = attributes.index*expectedStackedItemWidth + sut.itemSize.width;
							[[theValue(attributes.position.x) should] equal:expectedX withDelta:0.0000001];
						});
					});
				});
			});
		});
		context(@"NSCoding", ^{
			beforeEach(^{
				sut.numberOfItems = 10;
			});
			context(@"non keyed archives", ^{
				it(@"should raise with non keyed archivers", ^{
					[[theBlock(^{
						[NSArchiver archivedDataWithRootObject:sut];
					}) should] raiseWithName:NSInvalidArchiveOperationException];
				});
			});
			context(@"keyed archives", ^{
				__block NSData *archivedData = nil;
				__block MMCoverFlowLayout *unarchivedLayout = nil;

				beforeEach(^{
					archivedData = [NSKeyedArchiver archivedDataWithRootObject:sut];
					unarchivedLayout = [NSKeyedUnarchiver unarchiveObjectWithData:archivedData];
				});
				afterEach(^{
					archivedData = nil;
					unarchivedLayout = nil;
				});
				it(@"should encode", ^{
					[[archivedData shouldNot] beNil];
				});
				it(@"should decode", ^{
					[[unarchivedLayout shouldNot] beNil];
				});
				it(@"should decode the correct class", ^{
					[[unarchivedLayout should] beKindOfClass:[sut class]];
				});
				it(@"should encode contentHeight", ^{
					[[theValue(unarchivedLayout.contentHeight) should] equal:theValue(sut.contentHeight)];
				});
				it(@"should encode interItemSpacing", ^{
					[[theValue(unarchivedLayout.interItemSpacing) should] equal:theValue(sut.interItemSpacing)];
				});
				it(@"should encode stackedAngle", ^{
					[[theValue(unarchivedLayout.stackedAngle) should] equal:theValue(sut.stackedAngle)];
				});
				it(@"should encode selectedItemIndex", ^{
					[[theValue(unarchivedLayout.selectedItemIndex) should] equal:theValue(sut.selectedItemIndex)];
				});
				it(@"should encode numberOfItems", ^{
					[[theValue(unarchivedLayout.numberOfItems) should] equal:theValue(sut.numberOfItems)];
				});
				it(@"should encode stackedDistance", ^{
					[[theValue(unarchivedLayout.stackedDistance) should] equal:theValue(sut.stackedDistance)];
				});
				it(@"should encode verticalMargin", ^{
					[[theValue(unarchivedLayout.verticalMargin) should] equal:theValue(sut.verticalMargin)];
				});
			});
		});
	});
});

SPEC_END