//
//  ViewController.m
//  JPTool
//
//  Created by SunYang on 2017/10/31.
//  Copyright © 2017年 SunYang. All rights reserved.
//

#import "ViewController.h"
#import "TGClassObject.h"
#import <WebKit/WebKit.h>

@interface ViewController()

@property (unsafe_unretained) IBOutlet NSTextView *outputTextView;
@property (weak) IBOutlet NSTextField *superClassTF;
@property (weak) IBOutlet NSTextField *modelNameTF;
@property (weak) IBOutlet WKWebView *inputView;
@property (weak) IBOutlet NSButton *numberTypeCheckBox;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // load JSON Editor
    NSString* localPath = [[NSBundle mainBundle] pathForResource:@"je" ofType:@"html"];
    NSURL *fileURL = [NSURL fileURLWithPath:localPath];
    [self.inputView loadFileURL:fileURL allowingReadAccessToURL:fileURL];
}

- (IBAction)convertButtonClick:(id)sender {
    __weak typeof(self)weakSelf = self;
    [self.inputView evaluateJavaScript:@"sendData()" completionHandler:^(id _Nullable data, NSError * _Nullable error) {
        [weakSelf handleJSONString:data];
    }];
}

- (void)handleJSONString:(NSString *)JSONString {
    
    if (JSONString.length == 0) {
        self.outputTextView.string = @"No Data......";
        return;
    }
    
    NSError *error;
    NSLog(@"%@", JSONString);
    NSDictionary *JSONObject = [NSJSONSerialization JSONObjectWithData:[JSONString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
    if (error != nil) {
        self.outputTextView.string = error.localizedDescription;
        return;
    }
    
    NSMutableArray *classes = [NSMutableArray array];
    NSString *superClass = self.superClassTF.stringValue.length > 0 ? self.superClassTF.stringValue : @"NSObject";
    
    TGClassObject *rootObject = [TGClassObject new];
    [classes addObject:rootObject];
    rootObject.className = self.modelNameTF.stringValue.length > 0 ? self.modelNameTF.stringValue : @"BaseModel";
    TGClassObject.metaJSONString = JSONString;
    TGClassObject.trueNumberType = self.numberTypeCheckBox.state == NSControlStateValueOn;
    rootObject.properties = [TGClassObject handleDictionary:JSONObject container:classes];
    
    NSMutableString *fin = [NSMutableString string];
    for (TGClassObject *classObject in classes) {
        [fin appendFormat:@"\n"];
        if (classObject.nullProperties.count) {
            NSString *nullWarningString = [NSString stringWithFormat:@"#warning null values: {%@} set to NSString by default\n\n", [classObject.nullProperties componentsJoinedByString:@"/"]];
            [fin appendString:nullWarningString];
        }
        NSString *classString = [NSString stringWithFormat:@"@interface %@ : %@\n\n", classObject.className, superClass];
        [fin appendString:classString];
        for (NSString *property in classObject.properties) {
            [fin appendFormat:@"%@\n", property];
        }
        [fin appendString:@"\n@end\n"];
    }
    self.outputTextView.string = [fin copy];
}


@end















