/**
 * Ti.SPM
 * Copyright TiDev, Inc. 04/07/2022-Present. All Rights Reserved.
 * All Rights Reserved.
 */

"use strict";

exports.id = "ti.spm";
exports.cliVersion = ">=3.2";
exports.init = init;

/**
 * A function to inject SPM packages into the Xcode project.
 * The 24 char UUIDs should be random.
 * Each UUID should be uppercase (by convention) and each of the 3 UUID params unique.
 *
 * @param {Object} xobjs - the Xcode plist object graph
 * @param String swiftPackageFrameworkName Swift package framework name, e.g. MyPackage.
 * @param String swiftPackageProductName Swift package product name, e.g. MyPackageKit
 * @param String spmRemotePackageReference Swift package remote package reference name, e.g. MyPackage-iOS
 * @param String spmRepositoryURL SPM repository URL, e.g. https://github.com/some-company/MyPackage-iOS
 * @param String spmRepositoryVersionKind SPM repository kind, e.g. upToNextMajorVersion
 * @param String spmRepositoryMinVersion SPM repository minimum version, e.g. 3.0.0
 *
 */
function injectSPMPackage(
  xobjs,
  swiftPackageFrameworkName,
  swiftPackageProductName,
  spmRemotePackageReference,
  spmRepositoryURL,
  spmRepositoryVersionKind,
  spmRepositoryMinVersion
) {
  const swiftProductUUID = generateUUID24();
  const pbxBuildFileUUID = generateUUID24();
  const spmRemotePackageUUID = generateUUID24();

  // PBXBuildFile
  xobjs.PBXBuildFile[
    pbxBuildFileUUID + " /* " + swiftPackageFrameworkName + " in Frameworks */"
  ] = {
    isa: "PBXBuildFile",
    productRef: swiftProductUUID,
    fileRef_comment: swiftPackageProductName + " in Frameworks",
  };

  // PBXFrameworksBuildPhase
  Object.keys(xobjs.PBXFrameworksBuildPhase).forEach(function (buildPhaseUUID) {
    var buildPhase = xobjs.PBXFrameworksBuildPhase[buildPhaseUUID];
    if (buildPhase && typeof buildPhase === "object") {
      buildPhase.files.push({
        value: pbxBuildFileUUID,
        comment: swiftPackageProductName + " in Frameworks",
      });
    }
  });

  // PBXNativeTarget
  Object.keys(xobjs.PBXNativeTarget).forEach(function (nativeTargetUUID) {
    var nativeTarget = xobjs.PBXNativeTarget[nativeTargetUUID];
    if (nativeTarget && typeof nativeTarget === "object") {
      nativeTarget["packageProductDependencies"] =
        "(\n\t\t\t\t" +
        swiftProductUUID +
        " /* " +
        swiftPackageProductName +
        " */,\n\t\t\t)";
    }
  });

  // PBXProject
  // xobjs.PBXProject
  Object.keys(xobjs.PBXProject).forEach(function (pbxProjUUID) {
    var pbxProj = xobjs.PBXProject[pbxProjUUID];
    if (pbxProj && typeof pbxProj === "object") {
      pbxProj["packageReferences"] =
        "(\n\t\t\t\t" +
        spmRemotePackageUUID +
        ' /* XCRemoteSwiftPackageReference "' +
        spmRemotePackageReference +
        '" */,\n\t\t\t)';
    }
  });

  // XCRemoteSwiftPackageReference
  const remoteSwiftPackageReferenceID =
    spmRemotePackageUUID +
    ' /* XCRemoteSwiftPackageReference "' +
    spmRemotePackageReference +
    '" */';

  var xcRSPR = (xobjs["XCRemoteSwiftPackageReference"] = {});
  xcRSPR[remoteSwiftPackageReferenceID] = {
    isa: "XCRemoteSwiftPackageReference",
    repositoryURL: '"' + spmRepositoryURL + '"',
    requirement: {
      kind: spmRepositoryVersionKind,
      minimumVersion: spmRepositoryMinVersion,
    },
  };

  // XCSwiftPackageProductDependency
  const swiftPackageProductDependencyID =
    swiftProductUUID + " /* " + swiftPackageProductName + " */";
  var xcSPPD = (xobjs["XCSwiftPackageProductDependency"] = {});
  xcSPPD[swiftPackageProductDependencyID] = {
    isa: "XCSwiftPackageProductDependency",
    package:
      spmRemotePackageUUID +
      ' /* XCRemoteSwiftPackageReference "' +
      spmRemotePackageReference +
      '" */',
    productName: swiftPackageProductName,
  };
}

/**
 * Main entry point for our plugin which looks for the platform specific
 * plugin to invoke.
 *
 * @param {Object} logger The logger instance.
 * @param {Object} config The hook config.
 * @param {Object} cli The Titanium CLI instance.
 * @param {Object} appc The Appcelerator CLI instance.
 */
// eslint-disable-next-line no-unused-vars
function init(logger, config, cli) {
  cli.on("build.ios.xcodeproject", {
    pre: function (data) {
      var xobjs = data.args[0].hash.project.objects;

      injectSPMPackage(
        xobjs,
        "GoogleMaps",
        "GoogleMaps",
        "ios-maps-sdk",
        "https://github.com/googlemaps/ios-maps-sdk",
        "upToNextMajorVersion",
        "9.4.0"
      );
    },
  });
}

function generateUUID24() {
  let chars = "0123456789ABCDEF"; // hexadecimal characters
  let uuid = "";

  for (let i = 0; i < 24; i++) {
    let randomIndex = Math.floor(Math.random() * chars.length);
    uuid += chars[randomIndex];
  }

  return uuid;
}
