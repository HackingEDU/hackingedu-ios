//
//  GithubAuthenticatorView.m
//  Github-Auth-iOS
//
//  Created by buza on 9/27/12.
//  Copyright (c) 2012 BuzaMoto. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice,
//     this list of conditions and the following disclaimer.
//  2. Redistributions in binary form must reproduce the above copyright notice,
//     this list of conditions and the following disclaimer in the documentation
//     and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
//  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
//  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
//  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
//  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
//  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
//  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
//  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
//  POSSIBILITY OF SUCH DAMAGE.

#import "GithubAuthenticatorView.h"

#import "NSDictionary+UrlEncoding.h"

@interface GithubAuthenticatorView()
@property(nonatomic, strong) NSMutableData *data;
@property(nonatomic, strong) NSURLConnection *tokenRequestConnection;
@end

@implementation GithubAuthenticatorView

@synthesize data;
@synthesize authDelegate;
@synthesize tokenRequestConnection;

-(id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self)
    {
        self.authDelegate = nil;
        self.tokenRequestConnection = nil;
        self.data = [NSMutableData data];
        self.scalesPageToFit = YES;
        [self authorize];
    }
    
    return self;
}

-(void) dealloc
{
    [tokenRequestConnection cancel];
    self.delegate = nil;
}

-(void) authorize
{
    //Scopes: http://developer.github.com/v3/oauth/#scopes
    //user
    //public_repo
    //repo
    //repo:status
    //delete_repo
    //gist
        
    NSString *scope = @"user";
    
    NSString *requestURL = [NSString stringWithFormat:@"https://github.com/login/oauth/authorize?client_id=%@&redirect_uri=%@&scope=%@", GITHUB_CLIENT_ID, GITHUB_CALLBACK_URL, scope];
    
    NSURLRequest *urlReq = [NSURLRequest requestWithURL:[NSURL URLWithString:requestURL]];
    self.delegate = self;
    [self loadRequest:urlReq];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *responseURL = [request.URL absoluteString];
    
    NSString *codeString = [NSString stringWithFormat:@"%@/?code=", GITHUB_CALLBACK_URL];
    if([responseURL hasPrefix:codeString])
    {
        NSInteger strLen = [codeString length];
        NSString *code = [responseURL substringFromIndex:strLen];
        
        //Request the token.
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://github.com/login/oauth/access_token"]];
        
        NSDictionary *paramDict = [NSDictionary dictionaryWithObjectsAndKeys:code, @"code",
                                   GITHUB_CLIENT_ID, @"client_id",
                                   GITHUB_CALLBACK_URL, @"redirect_uri",
                                   GITHUB_CLIENT_SECRET, @"client_secret", nil];
        
        NSString *paramString = [paramDict urlEncodedString];
        
        NSString *charset = (NSString *)CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
        
        [request setHTTPMethod:@"POST"];
        [request addValue:[NSString stringWithFormat:@"application/x-www-form-urlencoded; charset=%@",charset] forHTTPHeaderField:@"Content-Type"];
        [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setHTTPBody:[paramString dataUsingEncoding:NSUTF8StringEncoding]];
        
        self.tokenRequestConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        
        [tokenRequestConnection start];

        return NO;
    }
    
    return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{

}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{

}


#pragma Mark NSURLConnection delegates

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse
{
    return cachedResponse;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)_data
{
    [self.data appendData:_data];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self.data setLength:0];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError *jsonError = nil;
    id jsonData = [NSJSONSerialization JSONObjectWithData:self.data options:0 error:&jsonError];
    if(jsonData && [NSJSONSerialization isValidJSONObject:jsonData])
    {
        NSString *accesstoken = [jsonData objectForKey:@"access_token"];
        if(accesstoken)
        {
            [self.authDelegate didAuth:accesstoken];
            return;
        }
    }

    [self.authDelegate didAuth:nil];
}

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)redirectResponse
{
    return request;
}



@end
