'# MWS Version: Version 2015.0 - Jan 16 2015 - ACIS 24.0.2 -

'# length = mm
'# frequency = GHz
'# time = ns
'# frequency range: fmin = 0 fmax = 3.7
'# created = '[VERSION]2015.0|24.0.2|20150116[/VERSION]


'@ use template: Antenna - Planar_3

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
Solver.FrequencyRange "0.85", "2.6"
Dim sDefineAt As String
sDefineAt = "0.9;2.6"
Dim sDefineAtName As String
sDefineAtName = "0.9;2.6"
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

'@ define material: FR-4 (loss free)

'[VERSION]2015.0|24.0.2|20150116[/VERSION]
With Material
     .Reset
     .Name "FR-4 (loss free)"
     .Folder ""
.FrqType "all" 
.Type "Normal" 
.SetMaterialUnit "GHz", "mm"
.Epsilon "4.3" 
.Mue "1.0" 
.Kappa "0.0" 
.TanD "0.0" 
.TanDFreq "0.0" 
.TanDGiven "False" 
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
.Colour "0.75", "0.95", "0.85" 
.Wireframe "False" 
.Transparency "0" 
.Create
End With

'@ new component: component1

'[VERSION]2015.0|24.0.2|20150116[/VERSION]
Component.New "component1"

'@ define brick: component1:SUBSTRATE

'[VERSION]2015.0|24.0.2|20150116[/VERSION]
With Brick
     .Reset 
     .Name "SUBSTRATE" 
     .Component "component1" 
     .Material "FR-4 (loss free)" 
     .Xrange "-Ws/2", "Ws/2" 
     .Yrange "-Ls/2", "-Ls/2+Lf+Lp+Lf" 
     .Zrange "-2.5", "0" 
     .Create
End With

'@ switch working plane

'[VERSION]2015.0|24.0.2|20150116[/VERSION]
Plot.DrawWorkplane "false"

'@ switch bounding box

'[VERSION]2015.0|24.0.2|20150116[/VERSION]
Plot.DrawBox "False"

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

'@ define brick: component1:GROUND

'[VERSION]2015.0|24.0.2|20150116[/VERSION]
With Brick
     .Reset 
     .Name "GROUND" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .Xrange "-Ws/2", "Ws/2" 
     .Yrange "-Ls/2 +Lg", "-Ls/2" 
     .Zrange "-2.535", "-2.5" 
     .Create
End With

'@ define brick: component1:PATCH

'[VERSION]2015.0|24.0.2|20150116[/VERSION]
With Brick
     .Reset 
     .Name "PATCH" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .Xrange "-Wp/2", "Wp/2" 
     .Yrange "-Ls/2+Lf", "-Ls/2+Lf+Lp" 
     .Zrange "0", "0.035" 
     .Create
End With

'@ define brick: component1:feed1

'[VERSION]2015.0|24.0.2|20150116[/VERSION]
With Brick
     .Reset 
     .Name "feed1" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .Xrange "-Wf/2", "Wf/2" 
     .Yrange "-Ls/2", "-Ls/2+Lf" 
     .Zrange "0", "0.035" 
     .Create
End With

'@ clear picks

'[VERSION]2015.0|24.0.2|20150116[/VERSION]
Pick.ClearAllPicks

'@ pick face

'[VERSION]2015.0|24.0.2|20150116[/VERSION]
Pick.PickFaceFromId "component1:feed1", "3"

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
     .Xrange "-1.5", "1.5" 
     .Yrange "-65", "-65" 
     .Zrange "0", "0.035" 
     .XrangeAdd "3*Wf", "3*Wf" 
     .YrangeAdd "0.0", "0.0" 
     .ZrangeAdd "1.635", "4*1.6" 
     .SingleEnded "False" 
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

'@ switch working plane

'[VERSION]2015.0|24.0.2|20150116[/VERSION]
Plot.DrawWorkplane "false"

'@ clear picks

'[VERSION]2015.0|24.0.2|20150116[/VERSION]
Pick.ClearAllPicks

''@ pick edge
'
''[VERSION]2015.0|24.0.2|20150116[/VERSION]
'Pick.PickEdgeFromId "component1:PATCH", "12", "2"
'
''@ chamfer edges of: component1:PATCH
'
''[VERSION]2015.0|24.0.2|20150116[/VERSION]
'Solid.ChamferEdge "26.35", "51.76", "False", "5"
'
''@ pick edge
'
''[VERSION]2015.0|24.0.2|20150116[/VERSION]
'Pick.PickEdgeFromId "component1:PATCH", "11", "3"
'
''@ chamfer edges of: component1:PATCH
'
''[VERSION]2015.0|24.0.2|20150116[/VERSION]
'Solid.ChamferEdge "26.35", "51.76", "True", "4"
'
''@ pick edge
'
''[VERSION]2015.0|24.0.2|20150116[/VERSION]
'Pick.PickEdgeFromId "component1:PATCH", "9", "4"
'
''@ chamfer edges of: component1:PATCH
'
''[VERSION]2015.0|24.0.2|20150116[/VERSION]
'Solid.ChamferEdge "26.35", "51.76", "False", "3"
'
''@ pick edge
'
''[VERSION]2015.0|24.0.2|20150116[/VERSION]
'Pick.PickEdgeFromId "component1:PATCH", "10", "1"
'
''@ chamfer edges of: component1:PATCH
'
''[VERSION]2015.0|24.0.2|20150116[/VERSION]
'Solid.ChamferEdge "26.35", "51.76", "True", "6"
'
'@ define frequency range

'[VERSION]2015.0|24.0.2|20150116[/VERSION]
Solver.FrequencyRange "0", "3.5"

'@ farfield plot options

'[VERSION]2015.0|24.0.2|20150116[/VERSION]
With FarfieldPlot 
     .Plottype "3D" 
     .Vary "angle1" 
     .Theta "0" 
     .Phi "0" 
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
     .SetFrequency "0.9" 
     .SetTime "0" 
     .SetColorByValue "True" 
     .DrawStepLines "False" 
     .DrawIsoLongitudeLatitudeLines "False" 
     .ShowStructure "False" 
     .SetStructureTransparent "False" 
     .SetFarfieldTransparent "False" 
     .SetSpecials "enablepolarextralines" 
     .SetPlotMode "Gain" 
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

''@ define brick: component1:feed2
'
''[VERSION]2015.0|24.0.2|20150116[/VERSION]
'With Brick
'     .Reset 
'     .Name "feed2" 
'     .Component "component1" 
'     .Material "Copper (annealed)" 
'     .Xrange "-Wf/2", "Wf/2" 
'     .Yrange "-Ls/2+Lf+Lp", "-Ls/2+Lf+Lp+Lf" 
'     .Zrange "0", "0.035" 
'     .Create
'End With
'
''@ pick face
'
''[VERSION]2015.0|24.0.2|20150116[/VERSION]
'Pick.PickFaceFromId "component1:feed2", "5"
'
''@ define port: 2
'
''[VERSION]2015.0|24.0.2|20150116[/VERSION]
'With Port 
'     .Reset 
'     .PortNumber "2" 
'     .Label "" 
'     .NumberOfModes "1" 
'     .AdjustPolarization "False" 
'     .PolarizationAngle "0.0" 
'     .ReferencePlaneDistance "0" 
'     .TextSize "50" 
'     .Coordinates "Picks" 
'     .Orientation "positive" 
'     .PortOnBound "False" 
'     .ClipPickedPortToBound "False" 
'     .Xrange "-1.55", "1.55" 
'     .Yrange "77.3", "77.3" 
'     .Zrange "0", "0.035" 
'     .XrangeAdd "3*Wf", "3*Wf" 
'     .YrangeAdd "0.0", "0.0" 
'     .ZrangeAdd "1.635", "4*1.6" 
'     .SingleEnded "False" 
'     .Create 
'End With
'
'@ define time domain solver parameters

'[VERSION]2015.0|24.0.2|20150116[/VERSION]
Mesh.SetCreator "High Frequency" 
With Solver 
     .Method "Hexahedral"
     .CalculationType "TD-S"
     .StimulationPort "All"
     .StimulationMode "1"
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

'@ define brick: component1:emptyspace1

'[VERSION]2015.0|24.0.2|20150116[/VERSION]
With Brick
     .Reset 
     .Name "emptyspace1" 
     .Component "component1" 
     .Material "Vacuum" 
     .Xrange "-Wp/2", "-Wp/2+W1" 
     .Yrange "-Ls/2+Lf+Lp-L1", "-Ls/2+Lf+Lp" 
     .Zrange "0", "0.035" 
     .Create
End With

'@ boolean subtract shapes: component1:PATCH, component1:emptyspace1

'[VERSION]2015.0|24.0.2|20150116[/VERSION]
Solid.Subtract "component1:PATCH", "component1:emptyspace1"

'@ define brick: component1:emptyspace2

'[VERSION]2015.0|24.0.2|20150116[/VERSION]
With Brick
     .Reset 
     .Name "emptyspace2" 
     .Component "component1" 
     .Material "Vacuum" 
     .Xrange "Wp/2-W1", "Wp/2" 
     .Yrange "-Ls/2+Lf+Lp-L1", "-Ls/2+Lf+Lp" 
     .Zrange "0", "0.035" 
     .Create
End With

'@ boolean subtract shapes: component1:PATCH, component1:emptyspace2

'[VERSION]2015.0|24.0.2|20150116[/VERSION]
Solid.Subtract "component1:PATCH", "component1:emptyspace2"

'@ define brick: component1:solid1

'[VERSION]2015.0|24.0.2|20150116[/VERSION]
With Brick
     .Reset 
     .Name "solid1" 
     .Component "component1" 
     .Material "Vacuum" 
     .Xrange "Wp/2-W1", "Wp/2" 
     .Yrange "-Ls/2+Lf", "-Ls/2+Lf+L1" 
     .Zrange "0", "0.035" 
     .Create
End With

'@ boolean subtract shapes: component1:PATCH, component1:solid1

'[VERSION]2015.0|24.0.2|20150116[/VERSION]
Solid.Subtract "component1:PATCH", "component1:solid1"

'@ define brick: component1:emptyspace4

'[VERSION]2015.0|24.0.2|20150116[/VERSION]
With Brick
     .Reset 
     .Name "emptyspace4" 
     .Component "component1" 
     .Material "Vacuum" 
     .Xrange "-Wp/2", "-Wp/2+W1" 
     .Yrange "-Ls/2+Lf", "-Ls/2+Lf+L1" 
     .Zrange "0", "0.035" 
     .Create
End With

'@ boolean subtract shapes: component1:PATCH, component1:emptyspace4

'[VERSION]2015.0|24.0.2|20150116[/VERSION]
Solid.Subtract "component1:PATCH", "component1:emptyspace4"

'@ define brick: component1:step1

'[VERSION]2015.0|24.0.2|20150116[/VERSION]
With Brick
     .Reset 
     .Name "step1" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .Xrange "-Wp/2+W1/n", "Wp/2-W1/n" 
     .Yrange "-Ls/2+Lf+L1-L1/n", "-Ls/2+Lf+Lp-L1+L1/n" 
     .Zrange "0", "0.035" 
     .Create
End With

'@ define brick: component1:step2

'[VERSION]2015.0|24.0.2|20150116[/VERSION]
With Brick
     .Reset 
     .Name "step2" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .Xrange "-Wp/2+2*W1/n", "Wp/2-2*W1/n" 
     .Yrange "-Ls/2+Lf+L1-2*L1/n", "-Ls/2+Lf+Lp-L1+2*L1/n" 
     .Zrange "0", "0.035" 
     .Create
End With

'@ define brick: component1:step3

'[VERSION]2015.0|24.0.2|20150116[/VERSION]
With Brick
     .Reset 
     .Name "step3" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .Xrange "-Wp/2+3*W1/n", "Wp/2-3*W1/n" 
     .Yrange "-Ls/2+Lf+L1-3*L1/n", "-Ls/2+Lf+Lp-L1+3*L1/n" 
     .Zrange "0", "0.035" 
     .Create
End With

'@ define brick: component1:step4

'[VERSION]2015.0|24.0.2|20150116[/VERSION]
With Brick
     .Reset 
     .Name "step4" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .Xrange "-Wp/2+4*W1/n", "Wp/2-4*W1/n" 
     .Yrange "-Ls/2+Lf+L1-4*L1/n", "-Ls/2+Lf+Lp-L1+4*L1/n" 
     .Zrange "0", "0.035" 
     .Create
End With

'@ define brick: component1:step5

'[VERSION]2015.0|24.0.2|20150116[/VERSION]
With Brick
     .Reset 
     .Name "step5" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .Xrange "-Wp/2+5*W1/n", "Wp/2-5*W1/n" 
     .Yrange "-Ls/2+Lf+L1-5*L1/n", "-Ls/2+Lf+Lp-L1+5*L1/n" 
     .Zrange "0", "0.035" 
     .Create
End With

'@ define brick: component1:step6

'[VERSION]2015.0|24.0.2|20150116[/VERSION]
With Brick
     .Reset 
     .Name "step6" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .Xrange "-Wp/2+6*W1/n", "Wp/2-6*W1/n" 
     .Yrange "0-Ls/2+Lf+L1-6*L1/n", "-Ls/2+Lf+Lp-L1+6*L1/n" 
     .Zrange "0", "0.035" 
     .Create
End With

'@ define brick: component1:step7

'[VERSION]2015.0|24.0.2|20150116[/VERSION]
With Brick
     .Reset 
     .Name "step7" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .Xrange "-Wp/2+7*W1/n", "Wp/2-7*W1/n" 
     .Yrange "-Ls/2+Lf+L1-7*L1/n", "-Ls/2+Lf+Lp-L1+7*L1/n" 
     .Zrange "0", "0.035" 
     .Create
End With

'@ define brick: component1:step8

'[VERSION]2015.0|24.0.2|20150116[/VERSION]
With Brick
     .Reset 
     .Name "step8" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .Xrange "-Wp/2+8*W1/n", "Wp/2-8*W1/n" 
     .Yrange "-Ls/2+Lf+L1-8*L1/n", "-Ls/2+Lf+Lp-L1+8*L1/n" 
     .Zrange "0", "0.035" 
     .Create
End With

'@ boolean add shapes: component1:PATCH, component1:step1

'[VERSION]2015.0|24.0.2|20150116[/VERSION]
Solid.Add "component1:PATCH", "component1:step1"

'@ boolean add shapes: component1:PATCH, component1:step2

'[VERSION]2015.0|24.0.2|20150116[/VERSION]
Solid.Add "component1:PATCH", "component1:step2"

'@ boolean add shapes: component1:PATCH, component1:step3

'[VERSION]2015.0|24.0.2|20150116[/VERSION]
Solid.Add "component1:PATCH", "component1:step3"

'@ boolean add shapes: component1:PATCH, component1:step4

'[VERSION]2015.0|24.0.2|20150116[/VERSION]
Solid.Add "component1:PATCH", "component1:step4"

'@ boolean add shapes: component1:PATCH, component1:step5

'[VERSION]2015.0|24.0.2|20150116[/VERSION]
Solid.Add "component1:PATCH", "component1:step5"

'@ boolean add shapes: component1:PATCH, component1:step6

'[VERSION]2015.0|24.0.2|20150116[/VERSION]
Solid.Add "component1:PATCH", "component1:step6"

'@ boolean add shapes: component1:PATCH, component1:step7

'[VERSION]2015.0|24.0.2|20150116[/VERSION]
Solid.Add "component1:PATCH", "component1:step7"

'@ boolean add shapes: component1:PATCH, component1:step8

'[VERSION]2015.0|24.0.2|20150116[/VERSION]
Solid.Add "component1:PATCH", "component1:step8"

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
     .SetFrequency "0.9" 
     .SetTime "0" 
     .SetColorByValue "True" 
     .DrawStepLines "False" 
     .DrawIsoLongitudeLatitudeLines "False" 
     .ShowStructure "True" 
     .SetStructureTransparent "True" 
     .SetFarfieldTransparent "True" 
     .SetSpecials "enablepolarextralines" 
     .SetPlotMode "Gain" 
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

'@ switch working plane

'[VERSION]2015.0|24.0.2|20150116[/VERSION]
Plot.DrawWorkplane "false"

'@ define brick: component1:step 9

'[VERSION]2015.0|24.0.2|20150116[/VERSION]
With Brick
     .Reset 
     .Name "step 9" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .Xrange "-Wp/2+9*W1/n", "Wp/2-9*W1/n" 
     .Yrange "-Ls/2+Lf+L1-9*L1/n", "-Ls/2+Lf+Lp-L1+9*L1/n" 
     .Zrange "0", "0.035" 
     .Create
End With

'@ boolean add shapes: component1:PATCH, component1:step 9

'[VERSION]2015.0|24.0.2|20150116[/VERSION]
Solid.Add "component1:PATCH", "component1:step 9"

'@ define frequency range

'[VERSION]2015.0|24.0.2|20150116[/VERSION]
Solver.FrequencyRange "0", "3.7"

'@ define material: FR-4 (loss free)

'[VERSION]2015.0|24.0.2|20150116[/VERSION]
With Material 
     .Reset 
     .Name "FR-4 (loss free)"
     .Folder ""
     .FrqType "all"
     .Type "Normal"
     .MaterialUnit "Frequency", "GHz"
     .MaterialUnit "Geometry", "mm"
     .MaterialUnit "Time", "s"
     .Epsilon "3.9"
     .Mue "1.0"
     .Sigma "0.0"
     .TanD "0.0"
     .TanDFreq "0.0"
     .TanDGiven "False"
     .TanDModel "ConstTanD"
     .EnableUserConstTanDModelOrderEps "False"
     .ConstTanDModelOrderEps "1"
     .SetElParametricConductivity "False"
     .ReferenceCoordSystem "Global"
     .CoordSystemType "Cartesian"
     .SigmaM "0.0"
     .TanDM "0.0"
     .TanDMFreq "0.0"
     .TanDMGiven "False"
     .TanDMModel "ConstTanD"
     .EnableUserConstTanDModelOrderMue "False"
     .ConstTanDModelOrderMue "1"
     .SetMagParametricConductivity "False"
     .DispModelEps  "None"
     .DispModelMue "None"
     .DispersiveFittingSchemeEps "1st Order"
     .DispersiveFittingSchemeMue "1st Order"
     .UseGeneralDispersionEps "False"
     .UseGeneralDispersionMue "False"
     .NLAnisotropy "False"
     .NLAStackingFactor "1"
     .NLADirectionX "1"
     .NLADirectionY "0"
     .NLADirectionZ "0"
     .Rho "0.0"
     .ThermalType "Normal"
     .ThermalConductivity "0.3"
     .HeatCapacity "0"
     .MetabolicRate "0"
     .BloodFlow "0"
     .VoxelConvection "0"
     .MechanicsType "Unused"
     .Colour "0.75", "0.95", "0.85" 
     .Wireframe "False" 
     .Reflection "False" 
     .Allowoutline "True" 
     .Transparentoutline "False" 
     .Transparency "0" 
     .Create
End With

'@ define material colour: FR-4 (loss free)

'[VERSION]2015.0|24.0.2|20150116[/VERSION]
With Material 
     .Name "FR-4 (loss free)"
     .Folder ""
     .Colour "0.75", "0.95", "0.85" 
     .Wireframe "False" 
     .Reflection "False" 
     .Allowoutline "True" 
     .Transparentoutline "False" 
     .Transparency "0" 
     .ChangeColour 
End With

'@ define material: FR-4 (loss free)

'[VERSION]2015.0|24.0.2|20150116[/VERSION]
With Material 
     .Reset 
     .Name "FR-4 (loss free)"
     .Folder ""
     .FrqType "all"
     .Type "Normal"
     .MaterialUnit "Frequency", "GHz"
     .MaterialUnit "Geometry", "mm"
     .MaterialUnit "Time", "s"
     .Epsilon "3.5"
     .Mue "1.0"
     .Sigma "0.0"
     .TanD "0.0"
     .TanDFreq "0.0"
     .TanDGiven "False"
     .TanDModel "ConstTanD"
     .EnableUserConstTanDModelOrderEps "False"
     .ConstTanDModelOrderEps "1"
     .SetElParametricConductivity "False"
     .ReferenceCoordSystem "Global"
     .CoordSystemType "Cartesian"
     .SigmaM "0.0"
     .TanDM "0.0"
     .TanDMFreq "0.0"
     .TanDMGiven "False"
     .TanDMModel "ConstTanD"
     .EnableUserConstTanDModelOrderMue "False"
     .ConstTanDModelOrderMue "1"
     .SetMagParametricConductivity "False"
     .DispModelEps  "None"
     .DispModelMue "None"
     .DispersiveFittingSchemeEps "1st Order"
     .DispersiveFittingSchemeMue "1st Order"
     .UseGeneralDispersionEps "False"
     .UseGeneralDispersionMue "False"
     .NLAnisotropy "False"
     .NLAStackingFactor "1"
     .NLADirectionX "1"
     .NLADirectionY "0"
     .NLADirectionZ "0"
     .Rho "0.0"
     .ThermalType "Normal"
     .ThermalConductivity "0.3"
     .HeatCapacity "0"
     .MetabolicRate "0"
     .BloodFlow "0"
     .VoxelConvection "0"
     .MechanicsType "Unused"
     .Colour "0.75", "0.95", "0.85" 
     .Wireframe "False" 
     .Reflection "False" 
     .Allowoutline "True" 
     .Transparentoutline "False" 
     .Transparency "0" 
     .Create
End With

'@ define material colour: FR-4 (loss free)

'[VERSION]2015.0|24.0.2|20150116[/VERSION]
With Material 
     .Name "FR-4 (loss free)"
     .Folder ""
     .Colour "0.75", "0.95", "0.85" 
     .Wireframe "False" 
     .Reflection "False" 
     .Allowoutline "True" 
     .Transparentoutline "False" 
     .Transparency "0" 
     .ChangeColour 
End With

'@ define material: FR-4 (loss free)

'[VERSION]2015.0|24.0.2|20150116[/VERSION]
With Material 
     .Reset 
     .Name "FR-4 (loss free)"
     .Folder ""
     .FrqType "all"
     .Type "Normal"
     .MaterialUnit "Frequency", "GHz"
     .MaterialUnit "Geometry", "mm"
     .MaterialUnit "Time", "s"
     .Epsilon "3.5"
     .Mue "1.0"
     .Sigma "0.0"
     .TanD "0.0"
     .TanDFreq "0.0"
     .TanDGiven "False"
     .TanDModel "ConstTanD"
     .EnableUserConstTanDModelOrderEps "False"
     .ConstTanDModelOrderEps "1"
     .SetElParametricConductivity "False"
     .ReferenceCoordSystem "Global"
     .CoordSystemType "Cartesian"
     .SigmaM "0.0"
     .TanDM "0.0"
     .TanDMFreq "0.0"
     .TanDMGiven "False"
     .TanDMModel "ConstTanD"
     .EnableUserConstTanDModelOrderMue "False"
     .ConstTanDModelOrderMue "1"
     .SetMagParametricConductivity "False"
     .DispModelEps  "None"
     .DispModelMue "None"
     .DispersiveFittingSchemeEps "1st Order"
     .DispersiveFittingSchemeMue "1st Order"
     .UseGeneralDispersionEps "False"
     .UseGeneralDispersionMue "False"
     .NLAnisotropy "False"
     .NLAStackingFactor "1"
     .NLADirectionX "1"
     .NLADirectionY "0"
     .NLADirectionZ "0"
     .Rho "0.0"
     .ThermalType "Normal"
     .ThermalConductivity "0.3"
     .HeatCapacity "0"
     .MetabolicRate "0"
     .BloodFlow "0"
     .VoxelConvection "0"
     .MechanicsType "Unused"
     .Colour "0.75", "0.95", "0.85" 
     .Wireframe "False" 
     .Reflection "False" 
     .Allowoutline "True" 
     .Transparentoutline "False" 
     .Transparency "0" 
     .Create
End With

'@ define material colour: FR-4 (loss free)

'[VERSION]2015.0|24.0.2|20150116[/VERSION]
With Material 
     .Name "FR-4 (loss free)"
     .Folder ""
     .Colour "0.75", "0.95", "0.85" 
     .Wireframe "False" 
     .Reflection "False" 
     .Allowoutline "True" 
     .Transparentoutline "False" 
     .Transparency "0" 
     .ChangeColour 
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
     .SetFrequency "0.9" 
     .SetTime "0" 
     .SetColorByValue "True" 
     .DrawStepLines "False" 
     .DrawIsoLongitudeLatitudeLines "False" 
     .ShowStructure "True" 
     .SetStructureTransparent "True" 
     .SetFarfieldTransparent "True" 
     .SetSpecials "enablepolarextralines" 
     .SetPlotMode "Gain" 
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


