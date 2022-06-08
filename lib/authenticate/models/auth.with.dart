// Copyright 2020 The Luminucx Inc. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/// Alleon representation of firebase auth Providers that alleon may support.
/// This list may change at anytime to suit needs of Alleon support Auths.
enum AuthWith {
  EmailLink,
  Facebook,
  Github,
  Google,
  OAuth,
  Phone,
  SAML,
  Twitter,
  Apple,
  Microsoft,
  GameCenter,
  Password,
  Yahoo,
  Anon,
}

const String GoogleAuthProviderID = "google.com";
const String FacebookAuthProviderID = "facebook.com";
const String EmailAuthProviderID = "password";
const String TwitterAuthProviderID = "twitter.com";
const String GitHubAuthProviderID = "github.com";
const String PhoneAuthProviderID = "phone";
const String GameCenterAuthProviderID = "gc.apple.com";
const String AppleAuthProviderID = "apple.com";
const String YahooAuthProviderID = "yahoo.com";
const String MicrosoftAuthProviderID = "hotmail.com";

const Map<String, AuthWith> authProviderIDMethods = {
  GoogleAuthProviderID: AuthWith.Google,
  FacebookAuthProviderID: AuthWith.Facebook,
  EmailAuthProviderID: AuthWith.EmailLink,
  TwitterAuthProviderID: AuthWith.Twitter,
  GitHubAuthProviderID: AuthWith.Github,
  PhoneAuthProviderID: AuthWith.Phone,
  GameCenterAuthProviderID: AuthWith.GameCenter,
  AppleAuthProviderID: AuthWith.Apple,
  YahooAuthProviderID: AuthWith.Yahoo,
  MicrosoftAuthProviderID: AuthWith.Microsoft,
};