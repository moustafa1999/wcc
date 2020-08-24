'# MWS Version: Version 2015.0 - Jan 16 2015 - ACIS 24.0.2 -

'# length = mm
'# frequency = GHz
'# time = ns
'# frequency range: fmin = 0 fmax = 3.6
'# created = '[VERSION]2015.0|24.0.2|20150116[/VERSION]


'@ use template: Antenna - Planar_8

'[VERSION]2015.0|24.0.2|20150116[/VERSION]
'set the units
With Units
    .Geometry "mm"
    .Frequency "GHz"
    .Voltage "V"
    .Resistance "Ohm"
    .Inductance "NanoH"
    .TemperatureUnit  "Kelvin"
    .Time "ns"
    .Current "A"
    .Conductance "Siemens"
    .Capacitance "PikoF"
End With
'----------------------------------------------------------------------------
Plot.DrawBox True
With Background
     .Type "Normal"
     .Epsilon "1.0"
     .Mue "1.0"
     .XminSpace "0.0"
     .XmaxSpace "0.0"
     .YminSpace "0.0"
     .YmaxSpace "0.0"
     .ZminSpace "0.0"
     .ZmaxSpace "0.0"
End With
With Boundary
     .Xmin "expanded open"
     .Xmax "expanded open"
     .Ymin "expanded open"
     .Ymax "expanded open"
     .Zmin "expanded open"
     .Zmax "expanded open"
     .Xsymmetry "none"
     .Ysymmetry "none"
     .Zsymmetry "none"
End With
' optimize mesh settings for planar structures
With Mesh
     .MergeThinPECLayerFixpoints "True"
     .RatioLimit "20"
     .AutomeshRefineAtPecLines "True", "6"
     .FPBAAvoidNonRegUnite "True"
     .ConsiderSpaceForLowerMeshLimit "False"
     .MinimumStepNumber "5"
     .AnisotropicCurvatureRefinement "True"
     .AnisotropicCurvatureRefinementFSM "True"
End With
With MeshSettings
     .SetMeshType "Hex"
     .Set "RatioLimitGeometry", "20"
     .Set "EdgeRefinementOn", "1"
     .Set "EdgeRefinementRatio", "6"
End With
With MeshSettings
     .SetMeshType "HexTLM"
     .Set "RatioLimitGeometry", "20"
End With
With MeshSettings
     .SetMeshType "Tet"
     .Set "VolMeshGradation", "1.5"
     .Set "SrfMeshGradation", "1.5"
End With
' change mesh adaption scheme to energy
' 		(planar structures tend to store high energy
'     	 locally at edges rather than globally in volume)
MeshAdaption3D.SetAdaptionStrategy "Energy"
' switch on FD-TET setting for accurate farfields
FDSolver.ExtrudeOpenBC "True"
PostProcess1D.ActivateOperation "vswr", "true"
PostProcess1D.ActivateOperation "yz-matrices", "true"
'----------------------------------------------------------------------------
'set the frequency range
Solver.FrequencyRange "0", "3.6"
Dim sDefineAt As String
sDefineAt = "0.698;0.7;2.4;3.4;3.6"
Dim sDefineAtName As String
sDefineAtName = "0.698;0.7;2.4;3.4;3.6"
Dim sDefineAtToken As String
sDefineAtToken = "f="
Dim aFreq() As String
aFreq = Split(sDefineAt, ";")
Dim aNames() As String
aNames = Split(sDefineAtName, ";")
Dim nIndex As Integer
For nIndex = LBound(aFreq) To UBound(aFreq)
Dim zz_val As String
zz_val = aFreq (nIndex)
Dim zz_name As String
zz_name = sDefineAtToken & aNames (nIndex)
' Define E-Field Monitors
With Monitor
    .Reset
    .Name "e-field ("& zz_name &")"
    .Dimension "Volume"
    .Domain "Frequency"
    .FieldType "Efield"
    .Frequency zz_val
    .Create
End With
' Define H-Field Monitors
With Monitor
    .Reset
    .Name "h-field ("& zz_name &")"
    .Dimension "Volume"
    .Domain "Frequency"
    .FieldType "Hfield"
    .Frequency zz_val
    .Create
End With
' Define Power flow Monitors
With Monitor
    .Reset
    .Name "power ("& zz_name &")"
    .Dimension "Volume"
    .Domain "Frequency"
    .FieldType "Powerflow"
    .Frequency zz_val
    .Create
End With
' Define Power loss Monitors
With Monitor
    .Reset
    .Name "loss ("& zz_name &")"
    .Dimension "Volume"
    .Domain "Frequency"
    .FieldType "Powerloss"
    .Frequency zz_val
    .Create
End With
' Define Farfield Monitors
With Monitor
    .Reset
    .Name "farfield ("& zz_name &")"
    .Domain "Frequency"
    .FieldType "Farfield"
    .Frequency zz_val
    .ExportFarfieldSource "False"
    .Create
End With
Next
'----------------------------------------------------------------------------
With MeshSettings
     .SetMeshType "Hex"
     .Set "Version", 1%
End With
With Mesh
     .MeshType "PBA"
End With
'set the solver type
ChangeSolverType("HF Time Domain")

'@ define material: Copper (annealed)

'[VERSION]2015.0|24.0.2|20150116[/VERSION]
With Material
     .Reset
     .Name "Copper (annealed)"
     .Folder ""
.FrqType "static" 
.Type "Normal" 
.SetMaterialUnit "Hz", "mm" 
.Epsilon "1" 
.Mue "1.0" 
.Kappa "5.8e+007" 
.TanD "0.0" 
.TanDFreq "0.0" 
.TanDGiven "False" 
.TanDModel "ConstTanD" 
.KappaM "0" 
.TanDM "0.0" 
.TanDMFreq "0.0" 
.TanDMGiven "False" 
.TanDMModel "ConstTanD" 
.DispModelEps "None" 
.DispModelMue "None" 
.DispersiveFittingSchemeEps "Nth Order" 
.DispersiveFittingSchemeMue "Nth Order" 
.UseGeneralDispersionEps "False" 
.UseGeneralDispersionMue "False" 
.FrqType "all" 
.Type "Lossy metal" 
.SetMaterialUnit "GHz", "mm" 
.Mue "1.0" 
.Kappa "5.8e+007" 
.Rho "8930.0" 
.ThermalType "Normal" 
.ThermalConductivity "401.0" 
.HeatCapacity "0.39" 
.MetabolicRate "0" 
.BloodFlow "0" 
.VoxelConvection "0" 
.MechanicsType "Isotropic" 
.YoungsModulus "120" 
.PoissonsRatio "0.33" 
.ThermalExpansionRate "17" 
.Colour "1", "1", "0" 
.Wireframe "False" 
.Reflection "False" 
.Allowoutline "True" 
.Transparentoutline "False" 
.Transparency "0" 
.Create
End With

'@ new component: component1

'[VERSION]2015.0|24.0.2|20150116[/VERSION]
Component.New "component1"

'@ define brick: component1:ground

'[VERSION]2015.0|24.0.2|20150116[/VERSION]
With Brick
     .Reset 
     .Name "ground" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .Xrange "-0.5*wgr", "0.5*wgr" 
     .Yrange "-0.5*lg", "0.5*lg" 
     .Zrange "0", "0.035" 
     .Create
End With

'@ define material: FR-4 (lossy)

'[VERSION]2015.0|24.0.2|20150116[/VERSION]
With Material
     .Reset
     .Name "FR-4 (lossy)"
     .Folder ""
.FrqType "all" 
.Type "Normal" 
.SetMaterialUnit "GHz", "mm"
.Epsilon "4.3" 
.Mue "1.0" 
.Kappa "0.0" 
.TanD "0.025" 
.TanDFreq "10.0" 
.TanDGiven "True" 
.TanDModel "ConstTanD" 
.KappaM "0.0" 
.TanDM "0.0" 
.TanDMFreq "0.0" 
.TanDMGiven "False" 
.TanDMModel "ConstKappa" 
.DispModelEps "None" 
.DispModelMue "None" 
.DispersiveFittingSchemeEps "General 1st" 
.DispersiveFittingSchemeMue "General 1st" 
.UseGeneralDispersionEps "False" 
.UseGeneralDispersionMue "False" 
.Rho "0.0" 
.ThermalType "Normal" 
.ThermalConductivity "0.3" 
.SetActiveMaterial "all" 
.Colour "0.94", "0.82", "0.76" 
.Wireframe "False" 
.Transparency "0" 
.Create
End With

'@ define brick: component1:substrate

'[VERSION]2015.0|24.0.2|20150116[/VERSION]
With Brick
     .Reset 
     .Name "substrate" 
     .Component "component1" 
     .Material "FR-4 (lossy)" 
     .Xrange "-0.5*wgr", "0.5*wgr" 
     .Yrange "-0.5*lg", "0.5*lg" 
     .Zrange "0.035", "0.035+hs" 
     .Create
End With

'@ define brick: component1:patch

'[VERSION]2015.0|24.0.2|20150116[/VERSION]
With Brick
     .Reset 
     .Name "patch" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .Xrange "-w/2", "w/2" 
     .Yrange "-l/2", "l/2" 
     .Zrange "ht+hs", "ht+hs+0.035" 
     .Create
End With

'@ define material: Nickel

'[VERSION]2015.0|24.0.2|20150116[/VERSION]
With Material
     .Reset
     .Name "Nickel"
     .Folder ""
.FrqType "all" 
.Type "Lossy metal" 
.SetMaterialUnit "GHz", "mm" 
.Mue "600" 
.Kappa "1.44e7" 
.Rho "8900" 
.ThermalType "Normal" 
.ThermalConductivity "91" 
.HeatCapacity "0.45" 
.MetabolicRate "0" 
.BloodFlow "0" 
.VoxelConvection "0" 
.MechanicsType "Isotropic" 
.YoungsModulus "207" 
.PoissonsRatio "0.31" 
.ThermalExpansionRate "13.1" 
.FrqType "static" 
.Type "Normal" 
.SetMaterialUnit "GHz", "mm" 
.Epsilon "1" 
.Mue "600" 
.Kappa "1.44e7" 
.TanD "0.0" 
.TanDFreq "0.0" 
.TanDGiven "False" 
.TanDModel "ConstTanD" 
.KappaM "0" 
.TanDM "0.0" 
.TanDMFreq "0.0" 
.TanDMGiven "False" 
.TanDMModel "ConstTanD" 
.DispModelEps "None" 
.DispModelMue "None" 
.DispersiveFittingSchemeEps "Nth Order" 
.DispersiveFittingSchemeMue "Nth Order" 
.UseGeneralDispersionEps "False" 
.UseGeneralDispersionMue "False" 
.Colour "0", "0.501961", "0.25098" 
.Wireframe "False" 
.Reflection "False" 
.Allowoutline "True" 
.Transparentoutline "False" 
.Transparency "0" 
.Create
End With

'@ define brick: component1:empty space

'[VERSION]2015.0|24.0.2|20150116[/VERSION]
With Brick
     .Reset 
     .Name "empty space" 
     .Component "component1" 
     .Material "Nickel" 
     .Xrange "-(wf/2+gpf)", "(wf/2+gpf)" 
     .Yrange "-l/2+fi", "-l/2" 
     .Zrange "ht+hs", "ht+hs+ht" 
     .Create
End With

'@ boolean subtract shapes: component1:patch, component1:empty space

'[VERSION]2015.0|24.0.2|20150116[/VERSION]
Solid.Subtract "component1:patch", "component1:empty space"

'@ define brick: component1:feedline

'[VERSION]2015.0|24.0.2|20150116[/VERSION]
With Brick
     .Reset 
     .Name "feedline" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .Xrange "-wf/2", "wf/2" 
     .Yrange "-l/2+fi", "-lg/2" 
     .Zrange "ht+hs", "ht+hs+ht" 
     .Create
End With

'@ boolean add shapes: component1:feedline, component1:patch

'[VERSION]2015.0|24.0.2|20150116[/VERSION]
Solid.Add "component1:feedline", "component1:patch"

'@ pick face

'[VERSION]2015.0|24.0.2|20150116[/VERSION]
Pick.PickFaceFromId "component1:substrate", "3"

'@ define port: 1

'[VERSION]2015.0|24.0.2|20150116[/VERSION]
With Port 
     .Reset 
     .PortNumber "1" 
     .Label "" 
     .NumberOfModes "1" 
     .AdjustPolarization "False" 
     .PolarizationAngle "0.0" 
     .ReferencePlaneDistance "0" 
     .TextSize "50" 
     .Coordinates "Picks" 
     .Orientation "positive" 
     .PortOnBound "False" 
     .ClipPickedPortToBound "False" 
     .Xrange "-132", "132" 
     .Yrange "-103", "-103" 
     .Zrange "0.035", "1.635" 
     .XrangeAdd "3*wf", "3*wf" 
     .YrangeAdd "0.0", "0.0" 
     .ZrangeAdd "ht+hs", "4*hs" 
     .SingleEnded "False" 
     .Create 
End With

'@ define monitor: e-field (f=0.698)

'[VERSION]2015.0|24.0.2|20150116[/VERSION]
With Monitor 
     .Reset 
     .Name "e-field (f=0.698)" 
     .Dimension "Volume" 
     .Domain "Frequency" 
     .FieldType "Efield" 
     .Frequency "0.698" 
     .UseSubvolume "False" 
     .SetSubvolume  "-183.04884138889",  "183.04884138889",  "-144.63784138889",  "144.63784138889",  "-43.237841388889",  "49.672841388889" 
     .Create 
End With

'@ define monitor: e-field (f=3.6)

'[VERSION]2015.0|24.0.2|20150116[/VERSION]
With Monitor 
     .Reset 
     .Name "e-field (f=3.6)" 
     .Dimension "Volume" 
     .Domain "Frequency" 
     .FieldType "Efield" 
     .Frequency "3.6" 
     .UseSubvolume "False" 
     .SetSubvolume  "-183.04884138889",  "183.04884138889",  "-144.63784138889",  "144.63784138889",  "-43.237841388889",  "49.672841388889" 
     .Create 
End With

'@ define time domain solver parameters

'[VERSION]2015.0|24.0.2|20150116[/VERSION]
Mesh.SetCreator "High Frequency" 
With Solver 
     .Method "Hexahedral"
     .CalculationType "TD-S"
     .StimulationPort "All"
     .StimulationMode "All"
     .SteadyStateLimit "-30.0"
     .MeshAdaption "False"
     .AutoNormImpedance "False"
     .NormingImpedance "50"
     .CalculateModesOnly "False"
     .SParaSymmetry "False"
     .StoreTDResultsInCache  "False"
     .FullDeembedding "False"
     .SuperimposePLWExcitation "False"
     .UseSensitivityAnalysis "False"
End With

'@ farfield plot options

'[VERSION]2015.0|24.0.2|20150116[/VERSION]
With FarfieldPlot 
     .Plottype "3D" 
     .Vary "angle1" 
     .Theta "90" 
     .Phi "90" 
     .Step "5" 
     .Step2 "5" 
     .SetLockSteps "True" 
     .SetPlotRangeOnly "False" 
     .SetThetaStart "0" 
     .SetThetaEnd "180" 
     .SetPhiStart "0" 
     .SetPhiEnd "360" 
     .SetTheta360 "False" 
     .SymmetricRange "False" 
     .SetTimeDomainFF "False" 
     .SetFrequency "-1" 
     .SetTime "0" 
     .SetColorByValue "True" 
     .DrawStepLines "False" 
     .DrawIsoLongitudeLatitudeLines "False" 
     .ShowStructure "False" 
     .SetStructureTransparent "False" 
     .SetFarfieldTransparent "False" 
     .SetSpecials "enablepolarextralines" 
     .SetPlotMode "Directivity" 
     .Distance "1" 
     .UseFarfieldApproximation "True" 
     .SetScaleLinear "False" 
     .SetLogRange "40" 
     .SetLogNorm "0" 
     .DBUnit "0" 
     .EnableFixPlotMaximum "False" 
     .SetFixPlotMaximumValue "1" 
     .SetInverseAxialRatio "False" 
     .SetAxesType "user" 
     .SetAntennaType "unknown" 
     .Phistart "1.000000e+000", "0.000000e+000", "0.000000e+000" 
     .Thetastart "0.000000e+000", "0.000000e+000", "1.000000e+000" 
     .PolarizationVector "0.000000e+000", "1.000000e+000", "0.000000e+000" 
     .SetCoordinateSystemType "spherical" 
     .SetAutomaticCoordinateSystem "True" 
     .SetPolarizationType "Linear" 
     .SlantAngle 0.000000e+000 
     .Origin "bbox" 
     .Userorigin "0.000000e+000", "0.000000e+000", "0.000000e+000" 
     .SetUserDecouplingPlane "False" 
     .UseDecouplingPlane "False" 
     .DecouplingPlaneAxis "X" 
     .DecouplingPlanePosition "0.000000e+000" 
     .LossyGround "False" 
     .GroundEpsilon "1" 
     .GroundKappa "0" 
     .EnablePhaseCenterCalculation "False" 
     .SetPhaseCenterAngularLimit "3.000000e+001" 
     .SetPhaseCenterComponent "boresight" 
     .SetPhaseCenterPlane "both" 
     .ShowPhaseCenter "True" 
     .StoreSettings
End With

'@ delete shape: component1:feedline

'[VERSION]2015.0|24.0.2|20150116[/VERSION]
Solid.Delete "component1:feedline"

'@ define brick: component1:solid1

'[VERSION]2015.0|24.0.2|20150116[/VERSION]
With Brick
     .Reset 
     .Name "solid1" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .Xrange "-w/2", "w/2" 
     .Yrange "-l/2", "l/2" 
     .Zrange "ht+hs", "ht+hs+0.035" 
     .Create
End With

'@ define brick: component1:feed line

'[VERSION]2015.0|24.0.2|20150116[/VERSION]
With Brick
     .Reset 
     .Name "feed line" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .Xrange "-wf/2", "wf/2" 
     .Yrange "-l/2", "-lg/2" 
     .Zrange "0.035+hs", "0.035+hs+0.035" 
     .Create
End With

'@ boolean add shapes: component1:solid1, component1:feed line

'[VERSION]2015.0|24.0.2|20150116[/VERSION]
Solid.Add "component1:solid1", "component1:feed line"

'@ pick end point

'[VERSION]2015.0|24.0.2|20150116[/VERSION]
Pick.PickEndpointFromId "component1:solid1", "9"

'@ align wcs with point

'[VERSION]2015.0|24.0.2|20150116[/VERSION]
WCS.AlignWCSWithSelected "Point"

'@ define curve polygon: curve1:polygon1

'[VERSION]2015.0|24.0.2|20150116[/VERSION]
With Polygon 
     .Reset 
     .Name "polygon1" 
     .Curve "curve1" 
     .Point "0", "42.7896" 
     .LineTo "0", "0" 
     .LineTo "-53.235", "0" 
     .LineTo "0", "42.7896" 
     .Create 
End With

'@ define extrudeprofile: component1:chamfer

'[VERSION]2015.0|24.0.2|20150116[/VERSION]
With ExtrudeCurve
     .Reset 
     .Name "chamfer" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .Thickness "ht+hs" 
     .Twistangle "0.0" 
     .Taperangle "0.0" 
     .Curve "curve1:polygon1" 
     .Create
End With

'@ boolean subtract shapes: component1:solid1, component1:chamfer

'[VERSION]2015.0|24.0.2|20150116[/VERSION]
Solid.Subtract "component1:solid1", "component1:chamfer"

'@ switch working plane

'[VERSION]2015.0|24.0.2|20150116[/VERSION]
Plot.DrawWorkplane "false"

'@ pick end point

'[VERSION]2015.0|24.0.2|20150116[/VERSION]
Pick.PickEndpointFromId "component1:solid1", "18"

'@ align wcs with point

'[VERSION]2015.0|24.0.2|20150116[/VERSION]
WCS.AlignWCSWithSelected "Point"

'@ define curve polygon: curve1:polygon1

'[VERSION]2015.0|24.0.2|20150116[/VERSION]
With Polygon 
     .Reset 
     .Name "polygon1" 
     .Curve "curve1" 
     .Point "0", "42.7896" 
     .LineTo "0", "0" 
     .LineTo "53.235", "0" 
     .LineTo "0", "42.7896" 
     .Create 
End With

'@ define extrudeprofile: component1:chamfer 2

'[VERSION]2015.0|24.0.2|20150116[/VERSION]
With ExtrudeCurve
     .Reset 
     .Name "chamfer 2" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .Thickness "-ht-hs" 
     .Twistangle "0.0" 
     .Taperangle "0.0" 
     .Curve "curve1:polygon1" 
     .Create
End With

'@ boolean subtract shapes: component1:solid1, component1:chamfer 2

'[VERSION]2015.0|24.0.2|20150116[/VERSION]
Solid.Subtract "component1:solid1", "component1:chamfer 2"

'@ pick end point

'[VERSION]2015.0|24.0.2|20150116[/VERSION]
Pick.PickEndpointFromId "component1:solid1", "23"

'@ align wcs with point

'[VERSION]2015.0|24.0.2|20150116[/VERSION]
WCS.AlignWCSWithSelected "Point"

'@ define curve polygon: curve1:polygon1

'[VERSION]2015.0|24.0.2|20150116[/VERSION]
With Polygon 
     .Reset 
     .Name "polygon1" 
     .Curve "curve1" 
     .Point "0", "-42.7896" 
     .LineTo "0", "0" 
     .LineTo "53.235", "0" 
     .LineTo "0", "-42.7896" 
     .Create 
End With

'@ define extrudeprofile: component1:chamfer

'[VERSION]2015.0|24.0.2|20150116[/VERSION]
With ExtrudeCurve
     .Reset 
     .Name "chamfer" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .Thickness "ht+hs" 
     .Twistangle "0.0" 
     .Taperangle "0.0" 
     .Curve "curve1:polygon1" 
     .Create
End With

'@ boolean subtract shapes: component1:solid1, component1:chamfer

'[VERSION]2015.0|24.0.2|20150116[/VERSION]
Solid.Subtract "component1:solid1", "component1:chamfer"

'@ pick end point

'[VERSION]2015.0|24.0.2|20150116[/VERSION]
Pick.PickEndpointFromId "component1:solid1", "28"

'@ align wcs with point

'[VERSION]2015.0|24.0.2|20150116[/VERSION]
WCS.AlignWCSWithSelected "Point"

'@ define curve polygon: curve1:polygon1

'[VERSION]2015.0|24.0.2|20150116[/VERSION]
With Polygon 
     .Reset 
     .Name "polygon1" 
     .Curve "curve1" 
     .Point "0", "-42.7896" 
     .LineTo "0", "0" 
     .LineTo "-53.235", "0" 
     .LineTo "0", "-42.7896" 
     .Create 
End With

'@ define extrudeprofile: component1:chamfer 3

'[VERSION]2015.0|24.0.2|20150116[/VERSION]
With ExtrudeCurve
     .Reset 
     .Name "chamfer 3" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .Thickness "-(ht+hs)" 
     .Twistangle "0.0" 
     .Taperangle "0.0" 
     .Curve "curve1:polygon1" 
     .Create
End With

'@ boolean subtract shapes: component1:solid1, component1:chamfer 3

'[VERSION]2015.0|24.0.2|20150116[/VERSION]
Solid.Subtract "component1:solid1", "component1:chamfer 3"

'@ clear picks

'[VERSION]2015.0|24.0.2|20150116[/VERSION]
Pick.ClearAllPicks 

