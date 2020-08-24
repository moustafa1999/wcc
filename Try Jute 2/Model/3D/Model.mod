'# MWS Version: Version 2015.0 - Jan 16 2015 - ACIS 24.0.2 -

'# length = mm
'# frequency = GHz
'# time = ns
'# frequency range: fmin = 1 fmax = 5
'# created = '[VERSION]2015.0|24.0.2|20150116[/VERSION]


'@ use template: Antenna - Try Jute 2

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
Solver.FrequencyRange "1", "5"

Dim sDefineAt As String
sDefineAt = "2.4"
Dim sDefineAtName As String
sDefineAtName = "2.4"
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



'@ define material: Platinum

'[VERSION]2015.0|24.0.2|20150116[/VERSION]
With Material
     .Reset
     .Name "Platinum"
     .Folder ""
.FrqType "all" 
.Type "Lossy metal" 
.SetMaterialUnit "GHz", "mm" 
.Mue "1" 
.Kappa "9.52e006" 
.Rho "21450.0" 
.ThermalType "Normal" 
.ThermalConductivity "70" 
.HeatCapacity "0.13" 
.MetabolicRate "0" 
.BloodFlow "0" 
.VoxelConvection "0" 
.MechanicsType "Isotropic" 
.YoungsModulus "171" 
.PoissonsRatio "0.39" 
.ThermalExpansionRate "9.1" 
.FrqType "static" 
.Type "Normal" 
.SetMaterialUnit "GHz", "mm" 
.Epsilon "1" 
.Mue "1" 
.Kappa "9.52e006" 
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
.Colour "0.25098", "0.501961", "0.501961" 
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


'@ define brick: component1:patch

'[VERSION]2015.0|24.0.2|20150116[/VERSION]
With Brick
     .Reset 
     .Name "patch" 
     .Component "component1" 
     .Material "Platinum" 
     .Xrange "-0.5*Wp", "0.5*Wp" 
     .Yrange "-0.5*Lp", "0.5*Lp" 
     .Zrange "0", "T" 
     .Create
End With


'@ define material: ShieldIt

'[VERSION]2015.0|24.0.2|20150116[/VERSION]
With Material 
     .Reset 
     .Name "ShieldIt"
     .Folder ""
     .FrqType "all"
     .Type "Lossy metal"
     .MaterialUnit "Frequency", "GHz"
     .MaterialUnit "Geometry", "mm"
     .MaterialUnit "Time", "ns"
     .MaterialUnit "Temperature", "Kelvin"
     .Mue "1"
     .Sigma "4034.29"
     .ReferenceCoordSystem "Global"
     .CoordSystemType "Cartesian"
     .NLAnisotropy "False"
     .NLAStackingFactor "1"
     .NLADirectionX "1"
     .NLADirectionY "0"
     .NLADirectionZ "0"
     .Rho "0"
     .ThermalType "Normal"
     .ThermalConductivity "0"
     .HeatCapacity "0"
     .MetabolicRate "0"
     .BloodFlow "0"
     .VoxelConvection "0"
     .MechanicsType "Unused"
     .Colour "1", "0", "0" 
     .Wireframe "False" 
     .Reflection "False" 
     .Allowoutline "True" 
     .Transparentoutline "False" 
     .Transparency "0" 
     .Create
End With 


'@ change material: component1:patch to: ShieldIt

'[VERSION]2015.0|24.0.2|20150116[/VERSION]
Solid.ChangeMaterial "component1:patch", "ShieldIt" 


'@ delete material: ShieldIt

'[VERSION]2015.0|24.0.2|20150116[/VERSION]
Material.Delete "ShieldIt"


'@ delete material: Platinum

'[VERSION]2015.0|24.0.2|20150116[/VERSION]
Material.Delete "Platinum"


'@ define material: ShieldIt

'[VERSION]2015.0|24.0.2|20150116[/VERSION]
With Material 
     .Reset 
     .Name "ShieldIt"
     .Folder ""
     .FrqType "all"
     .Type "Lossy metal"
     .MaterialUnit "Frequency", "GHz"
     .MaterialUnit "Geometry", "mm"
     .MaterialUnit "Time", "ns"
     .MaterialUnit "Temperature", "Kelvin"
     .Mue "1"
     .Sigma "4034.29"
     .ReferenceCoordSystem "Global"
     .CoordSystemType "Cartesian"
     .NLAnisotropy "False"
     .NLAStackingFactor "1"
     .NLADirectionX "1"
     .NLADirectionY "0"
     .NLADirectionZ "0"
     .Rho "0"
     .ThermalType "Normal"
     .ThermalConductivity "0"
     .HeatCapacity "0"
     .MetabolicRate "0"
     .BloodFlow "0"
     .VoxelConvection "0"
     .MechanicsType "Unused"
     .Colour "0.501961", "0.501961", "0" 
     .Wireframe "False" 
     .Reflection "False" 
     .Allowoutline "True" 
     .Transparentoutline "False" 
     .Transparency "0" 
     .Create
End With 


'@ define brick: component1:patch

'[VERSION]2015.0|24.0.2|20150116[/VERSION]
With Brick
     .Reset 
     .Name "patch" 
     .Component "component1" 
     .Material "ShieldIt" 
     .Xrange "-0.5*Wp", "0.5*Wp" 
     .Yrange "-0.5*Lp", "0.5*Lp" 
     .Zrange "0", "T" 
     .Create
End With


'@ define brick: component1:feed

'[VERSION]2015.0|24.0.2|20150116[/VERSION]
With Brick
     .Reset 
     .Name "feed" 
     .Component "component1" 
     .Material "ShieldIt" 
     .Xrange "-0.5*Wf", "0.5*Wf" 
     .Yrange "-0.5*Lp", "-0.5*Lp-Lf" 
     .Zrange "0", "T" 
     .Create
End With


