(* ::Package:: *)

(************************************************************************)
(* This file was generated automatically by the Mathematica front end.  *)
(* It contains Initialization cells from a Notebook file, which         *)
(* typically will have the same name as this file except ending in      *)
(* ".nb" instead of ".m".                                               *)
(*                                                                      *)
(* This file is intended to be loaded into the Mathematica kernel using *)
(* the package loading commands Get or Needs.  Doing so is equivalent   *)
(* to using the Evaluate Initialization Cells menu command in the front *)
(* end.                                                                 *)
(*                                                                      *)
(* DO NOT EDIT THIS FILE.  This entire file is regenerated              *)
(* automatically each time the parent Notebook file is saved in the     *)
(* Mathematica front end.  Any changes you make to this file will be    *)
(* overwritten.                                                         *)
(************************************************************************)



(* ::Input::Initialization:: *)
(*"
Copyright (C) 2013-2016, Anton K. Cyrol, Mario Mitter, Jan M. Pawlowski and Nils Strodthoff.
This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
"*)


(* ::Input::Initialization:: *)
formTracerInstaller::allowinternetuse="You have forbidden Mathematica to access the internet. Either allow Mathematica to access the internet or download the FormTracer from https://github.com/FormTracer/FormTracer manually.";
If[Not["AllowInternetUse" /. SystemInformation["Network"]],
Message[formTracerInstaller::allowinternetuse];
Abort[];
];


(* ::Input::Initialization:: *)
(* just for backwards compatibility *)
If[ToString[Context[URLDownload]]=!="System`",URLDownload=URLSave];


(* ::Input::Initialization:: *)
formTracerRepositoryAddress="https://raw.githubusercontent.com/FormTracer/FormTracer/master/";


(* ::Input::Initialization:: *)
If[Head[formTracerZipLocation]=!=String,formTracerZipLocation=formTracerRepositoryAddress<>"FormTracer.zip"];
formTracerInstallDir=FileNameJoin[{$UserBaseDirectory,"Applications"}];


(* ::Input::Initialization:: *)
formTracerInstaller::zipdownloadfailed="Download from "<>formTracerZipLocation<>" failed.";
formTracerInstaller::installationfailed="\nInstallation failed. Please read the error messages for more information!";

formTracerArchive=FileNameJoin[{$TemporaryDirectory,"FormTracer.zip"}];
URLDownload[formTracerZipLocation,formTracerArchive]

tmpFormTracerImport=Import[formTracerArchive];
If[tmpFormTracerImport==="{\"error\":\"Not Found\"}"||tmpFormTracerImport==="404: Not Found",Message[formTracerInstaller::zipdownloadfailed];Abort[];];

newVersionString=Version/.List@@Import[formTracerArchive,FileNameJoin[{"FormTracer","PacletInfo.m"}]];
formTracerFiles=FileNameJoin[{formTracerInstallDir,#}]&/@Import[formTracerArchive];
formTracerFilesExist=FileExistsQ/@formTracerFiles;
formTracerExistingInstallation=Or@@formTracerFilesExist;
formTracerExistingPacletInfo=FileNameJoin[{formTracerInstallDir,"FormTracer","PacletInfo.m"}];
formTracerExistingVersionString=If[FileExistsQ[formTracerExistingPacletInfo],Version/.List@@Import[formTracerExistingPacletInfo],"unknown"];


(* ::Input::Initialization:: *)
deleteExisting=False;
deleteExisting=If[formTracerExistingInstallation,
ChoiceDialog["The installer has found an existing FormTracer installation.
Do you want to overwrite the existing installation version "<>formTracerExistingVersionString<>" with version "<>newVersionString<>"?
Otherwise the installation will be aborted.",
WindowTitle->"FormTracer Installation",WindowSize->{Medium,All}],False];

If[deleteExisting,DeleteFile[Pick[formTracerFiles,formTracerFilesExist]]];

If[formTracerExistingInstallation&&deleteExisting===False,
(*abort installation*)
Print["FormTracer installation aborted."];
Quiet[DeleteFile[formTracerArchive]];,
(*install FormTracer*)
installationSuccess=Check[
ExtractArchive[formTracerArchive,formTracerInstallDir];
DeleteFile[formTracerArchive];
<<"FormTracer`";
,$Failed];
If[installationSuccess===$Failed,
(*installation failed*)
Message[formTracerInstaller::installationfailed];,
(*installation successful*)
RebuildPacletData[];
Print["
Installation was successful. Happy tracing!
Search for FormTracer in the documentation center to get started!
"];
(*check whether FORM was found*)
If[Not[FormTracer`Private`formChecked],
If[ChoiceDialog["FORM was not found on your computer. Do you want to install it?

If you choose not do to so, you can either install FORM manually or install it later with InstallFORM[].",
WindowTitle->"Install FORM",WindowSize->{Medium,All}],
formInstallationSuccessfull=True;
Check[FormTracer`InstallFORM[];,formInstallationSuccessfull=False;];
If[formInstallationSuccessfull,Print["FORM was successfully installed, you can now start tracing."];];
];
];
];
];
