//
//  _51201_SnakeTests.m
//  151201_SnakeTests
//
//  Created by shoshino21 on 12/3/15.
//  Copyright (c) 2015 shoshino21. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "SHOSnake.h"

@interface _51201_SnakeTests : XCTestCase {
  SHOSnake *snake;
  SHOSnakeBoardSize *boardSize;
}

@end

@implementation _51201_SnakeTests

- (void)setUp {
  [super setUp];
  // Put setup code here. This method is called before the invocation of each test method in the class.
  boardSize = [[SHOSnakeBoardSize alloc] initWithWidth:9 height:9];
  snake = [[SHOSnake alloc] initWithLength:2 boardSize:boardSize];
}

- (void)tearDown {
  // Put teardown code here. This method is called after the invocation of each test method in the class.
  [super tearDown];
}

- (void)testSnakePoint {
  SHOSnakePoint *headPoint = [[snake points] firstObject];
  XCTAssertEqual(headPoint.x, 5);
  XCTAssertEqual(headPoint.y, 5);
}

- (void)testHeadHitBody {
  snake = [[SHOSnake alloc] initWithLength:10 boardSize:boardSize];
  [snake toDirection:SHOSnakeDirectionUp];
  [snake move];
  [snake toDirection:SHOSnakeDirectionRight];
  [snake move];
  [snake toDirection:SHOSnakeDirectionDown];
  [snake move];
  XCTAssertEqual([snake isHeadHitBody], YES, @"isHeadHitBody must be YES");
}

- (void)testIncreaseLength {
  SHOSnakePoint *lastPoint = [[snake points] lastObject];
  XCTAssertEqual(lastPoint.x, 6);
  XCTAssertEqual(lastPoint.y, 5);
  XCTAssertEqual(snake.length, 2);

  [snake increaseLength:2];
  lastPoint = [[snake points] lastObject];
  XCTAssertEqual(lastPoint.x, 8);
  XCTAssertEqual(lastPoint.y, 5);
  XCTAssertEqual(snake.length, 4);

  [snake increaseLength:2];
  lastPoint = [[snake points] lastObject];
  XCTAssertEqual(lastPoint.x, 1);
  XCTAssertEqual(lastPoint.y, 5);
  XCTAssertEqual(snake.length, 6);
}

- (void)testToDirection {
  BOOL success;
  success = [snake toDirection:SHOSnakeDirectionRight];
  XCTAssertEqual(success, NO);
  [snake move];
  XCTAssertEqual([snake isHeadHitPoint:[SHOSnakePoint snakePointWithX:4 Y:5]], YES);

  success = [snake toDirection:SHOSnakeDirectionUp];
  XCTAssertEqual(success, YES);
  [snake move];
  [snake move];
  XCTAssertEqual([snake isHeadHitPoint:[SHOSnakePoint snakePointWithX:4 Y:3]], YES);

  success = [snake toDirection:SHOSnakeDirectionDown];
  XCTAssertEqual(success, NO);
  success = [snake toDirection:SHOSnakeDirectionLeft];
  XCTAssertEqual(success, YES);
}

- (void)testHeadHitPoint {
  SHOSnakePoint *targetPoint = [SHOSnakePoint snakePointWithX:7 Y:7];

  [snake toDirection:SHOSnakeDirectionDown];
  [snake move];
  XCTAssertEqual([snake isHeadHitPoint:targetPoint], NO);
  [snake move];
  XCTAssertEqual([snake isHeadHitPoint:targetPoint], NO);

  [snake toDirection:SHOSnakeDirectionRight];
  [snake move];
  XCTAssertEqual([snake isHeadHitPoint:targetPoint], NO);
  [snake move];
  XCTAssertEqual([snake isHeadHitPoint:targetPoint], YES);
}

- (void)testThroughBound {
  [snake toDirection:SHOSnakeDirectionUp];
  for (int i = 0; i < 6; i++) {
    [snake move];
  }
  XCTAssertEqual([snake isHeadHitPoint:[SHOSnakePoint snakePointWithX:5 Y:8]], YES);

  [snake increaseLength:4];
  SHOSnakePoint *lastPoint = [[snake points] lastObject];
  XCTAssertEqual(lastPoint.x, 5);
  XCTAssertEqual(lastPoint.y, 4);

  [snake toDirection:SHOSnakeDirectionRight];
  for (int i = 0; i < 7; i++) {
    [snake move];
  }
  XCTAssertEqual([snake isHeadHitPoint:[SHOSnakePoint snakePointWithX:3 Y:8]], YES);

  [snake toDirection:SHOSnakeDirectionDown];
  for (int i = 0; i < 7; i++) {
    [snake move];
  }
  XCTAssertEqual([snake isHeadHitPoint:[SHOSnakePoint snakePointWithX:3 Y:6]], YES);

  [snake toDirection:SHOSnakeDirectionLeft];
  for (int i = 0; i < 10; i++) {
    [snake move];
  }
  XCTAssertEqual([snake isHeadHitPoint:[SHOSnakePoint snakePointWithX:2 Y:6]], YES);
}

@end
