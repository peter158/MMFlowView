//
//  MMPDFPageDecoderSpec.m
//  MMFlowViewDemo
//
//  Created by Markus Müller on 18.12.13.
//  Copyright 2013 www.isnotnil.com. All rights reserved.
//

#import "Kiwi.h"
#import "MMPDFPageDecoder.h"
#import <Quartz/Quartz.h>

SPEC_BEGIN(MMPDFPageDecoderSpec)

describe(@"MMPDFPageDecoder", ^{
	__block MMPDFPageDecoder *sut = nil;
	__block CGImageRef imageRef = NULL;
	__block PDFDocument *document = nil;
	__block PDFPage *pdfPage = nil;

	beforeAll(^{
		NSURL *resource = [[NSBundle bundleForClass:[self class]] URLForResource:@"Test" withExtension:@"pdf"];
		document = [[PDFDocument alloc] initWithURL:resource];
		pdfPage = [document pageAtIndex:0];
	});
	afterAll(^{
		document = nil;
		pdfPage = nil;
	});
	context(@"a new instance", ^{
		beforeEach(^{
			sut = [[MMPDFPageDecoder alloc] init];
		});
		afterEach(^{
			if (imageRef) {
				CGImageRelease(imageRef);
				imageRef = NULL;
			}
			sut = nil;
		});
		it(@"should exist", ^{
			[[sut shouldNot] beNil];
		});
		it(@"should conform to MMImageDecoderProtocol", ^{
			[[sut should] conformToProtocol:@protocol(MMImageDecoderProtocol)];
		});
		it(@"should respond to newCGImageFromItem:", ^{
			[[sut should] respondToSelector:@selector(newCGImageFromItem:)];
		});
		it(@"should respond to imageFromItem:", ^{
			[[sut should] respondToSelector:@selector(imageFromItem:)];
		});
		it(@"should have a maxPixelSize of zero", ^{
			[[theValue(sut.maxPixelSize) should] beZero];
		});
		context(@"setting the maxPixelSize to 100", ^{
			beforeEach(^{
				sut.maxPixelSize = 100;
			});
			it(@"should have a maxPixelSize of 100", ^{
				[[theValue(sut.maxPixelSize) should] equal:theValue(100)];
			});
			context(@"newCGImageFromItem:", ^{
				context(@"creating an image from a PDFPage", ^{
					beforeEach(^{
						imageRef = [sut newCGImageFromItem:pdfPage];
					});
					it(@"should return an image", ^{
						[[theValue(imageRef != NULL) should] beTrue];
					});
					it(@"should have a width less or equal 100", ^{
						[[theValue(CGImageGetWidth(imageRef)) should] beLessThanOrEqualTo:theValue(100)];
					});
					it(@"should have a height less or equal 100", ^{
						[[theValue(CGImageGetHeight(imageRef)) should] beLessThanOrEqualTo:theValue(100)];
					});
				});
				context(@"creating an image from a CGPDFPageRef", ^{
					beforeEach(^{
						imageRef = [sut newCGImageFromItem:(id)[pdfPage pageRef]];
					});
					it(@"should return an image", ^{
						[[theValue(imageRef != NULL) should] beTrue];
					});
					it(@"should have a width less or equal 100", ^{
						[[theValue(CGImageGetWidth(imageRef)) should] beLessThanOrEqualTo:theValue(100)];
					});
					it(@"should have a height less or equal 100", ^{
						[[theValue(CGImageGetHeight(imageRef)) should] beLessThanOrEqualTo:theValue(100)];
					});
				});
				context(@"invoking with a non pdf item", ^{
					beforeEach(^{
						imageRef = [sut newCGImageFromItem:@"Test"];
					});
					it(@"should not return an image", ^{
						[[theValue(imageRef == NULL) should] beTrue];
					});
				});
			});
			context(@"imageFromItem:", ^{
				__block NSImage *image = nil;
				
				afterEach(^{
					image = nil;
				});
				context(@"creating an image from a PDFPage", ^{
					beforeEach(^{
						image = [sut imageFromItem:pdfPage];
					});
					it(@"should return an image", ^{
						[[image shouldNot] beNil];
					});
					it(@"should return an NSImage", ^{
						[[image should] beKindOfClass:[NSImage class]];
					});
					
				});
				context(@"creating an image from a CGPDFPageRef", ^{
					beforeEach(^{
						image = [sut imageFromItem:(id)[pdfPage pageRef]];
					});
					it(@"should return an image", ^{
						[[image shouldNot] beNil];
					});
				});
				context(@"invoking with a non pdf item", ^{
					it(@"should not return an image", ^{
						[[[sut imageFromItem:@"Test"] should] beNil];
					});
				});
			});
		});
		
	});
});

SPEC_END
