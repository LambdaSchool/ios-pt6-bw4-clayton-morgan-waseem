//
//  LSIMortgage.h
//  BW4MortgageCalculator
//
//  Created by Waseem Idelbi on 10/14/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
NS_SWIFT_NAME(Mortgage)
@interface LSIMortgage : NSObject

@property (nonatomic, copy, nullable)NSString *name;
@property (nonatomic) int term;
@property (nonatomic) int principal;
@property (nonatomic) int downPayment;
@property (nonatomic) double interestRate;
@property (nonatomic) double monthlyPayment;
@property (nonatomic) double totalCost;

- (instancetype)initWithTerm:(int)term name:(NSString *)name principal:(int)principal interestRate:(double)interestRate downPayment:(int)downPayment montlyPayment:(double)montlyPayment totalCost:(double)totalCost;

- (NSDictionary *)toDictionary;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;


@end

NS_ASSUME_NONNULL_END
