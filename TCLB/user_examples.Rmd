---
title: "Examples"
author: "Paweł Obrępalski"
date: "July 4, 2017"
output: html_document
---
#Example cases

In this section, a few case files will be presented, along with notes on their structure and usage of most popular functions. All of them(and some others) can be found in `TCLB/examples` catalogue(TODO: powrzucać te przykłady).

##Simple case

Below is presented a simple 3-Dimensional case, with a ball in the middle of the domain. Velocity inlet is used on one side and pressure outlet on the another one(TODO:Orientacja NEWS). Notice how each dimension of the ball is specified in different way, yet it is still placed exactly in the middle of the domain:

```xml
<?xml version="1.0"?>
<CLBConfig version="2.0" output="output/test">
    <Geometry nx="128" ny="128" nz="128">
        <MRT><Box/></MRT>
        <WVelocity name="Inlet"><Box nx="1"/></WVelocity>
        <EPressure><Box dx="-1"/></EPressure>
        <Wall mask = "ALL">
            <Sphere dx="54" nx="20" dy="54" fy="74" dz="-74" nz="20"/>
        </Wall>
    </Geometry>
    <Model>
        <Params Velocity-Inlet="0.1"/>
        <Params nu="0.05"/>
    </Model>
    <VTK Iterations="100" what = "U,P"/>
    <Solve Iterations="1000"/>
</CLBConfig>
```
Note: It is not necessary to specify `<Box nx="1">` for Inlet/Outlet, as it is default value. 

##Defining Units

```xml
<?xml version="1.0"?>
<CLBConfig version="2.0" output="output/test">
    <Units>
        <Params Velocity="1m/s" gauge="0.1"/>
        <Params Viscosity="0.01m2/s" gauge="0.01"/>
    </Units>
    <Geometry nx="12.8m" ny="12.8m" nz="12.8m">
        <MRT><Box/></MRT>
        <WVelocity name="Inlet"><Box nx="1"/></WVelocity>
        <EPressure><Box dx="-1"/></EPressure>
        <Wall mask = "ALL">
            <Sphere dx="54" nx="20" dy="54" fy="74" dz="-74" nz="20"/>
        </Wall>
    </Geometry>
    <Model>
        <Params Velocity-Inlet="1m/s"/>
        <Params nu="0.05m2/s"/>
    </Model>
    <VTK Iterations="100" what = "U,P"/>
    <Solve Iterations="1000"/>
</CLBConfig>

```
Sets units in such a way that real-world units agree with LB units. Here $1m = 1/0.1=10$, which means that each meter is equal to 10 elements in grid and $0.01[\frac{m^2}{s}]  = \frac{0.01}{0.01} = 1 => 1 Iteration[s] = \frac{1}{10^2}$, so 1 second in real world is equal to 100 iterations. 

Notice how parameters in `<Model>` and `Geometry` are specified and how generated case is the same as in previous example.

It is important not to over-construct gauge variables. If `<Params Size="1m" gauge = "10"/>` would be added to the example above it would result in an error, as too many gauge gauges would be assigned.

##Control elements

```xml
<?xml version="1.0"?>
<CLBConfig version="2.0" output="output/test">
    <Geometry nx="128" ny="128" nz="128">
        <MRT><Box/></MRT>
        <WVelocity name="Inlet"><Box nx="1"/></WVelocity>
        <EPressure><Box dx="-1"/></EPressure>
        <Wall mask = "ALL">
            <Sphere dx="54" nx="20" dy="54" fy="74" dz="-74" nz="20"/>
        </Wall>
    </Geometry>
    <Model>
        <Params Velocity-Inlet="0.1"
                nu="0.05"/>
    </Model>
    <VTK Iterations="100" what = "U,P"/>
    <Solve Iterations="1000"/>
    <Control Iterations="1000">
        <CSV file="file.csv" Time="x*1000">
        <Params Velocity="y*0.02+0.05"/>
    </CSV>
</Control>
</CLBConfig>
```
Changes `Velocity` according to the contents of `file.csv`. Here column 'x' is used to compute time and 'y' is used to calculate 'Velocity' value. Notice also that `Velocity` and `nu` parameters are given in `<Model>` container, without the need of creating separate tags for each parameter.

##Importing geometry

It is possible to import geometry from `.stl` files. It can be done by using `<STL file="path_to_file"/>`. Additional arguments allow user to resize, rotate, and translate geometry. ParaView(TODO: podlinkować odpowiedni podrozdział) can open `.stl` files and provides a fast way of estabilishing correct import parameters. Imported geometry can be used along with geometry primitives, shown in other examples.

```xml
<?xml version="1.0"?>
<CLBConfig version="2.0" output="output/">
        <Units>
                <Params size="1m" gauge="70" />
                <Params nu="1.4e-5m2/s" gauge="0.0001"/>  (TODO: nie działa jak usunie wpisze się w jednym <Params/> - dlaczego?)
        </Units>
        <Geometry nx="6m" ny="1m" nz="1m">
                <MRT><Box/></MRT>
                <WVelocity><Inlet/></WVelocity>
                <EPressure><Outlet/></EPressure>
                <Wall mask="ALL">
                        <Channel/>
                        <STL file="example/data/ahmed.stl" scale="1mm" Xrot="-90d" x="70" y="5cm" z="0.5m" side = "out"/>
                </Wall>
        </Geometry>
        <Model>
                <Params Velocity="0.01"/>
        </Model>
        <VTK Iterations="1000"/>
        <Solve Iterations="10000"/>
</CLBConfig>
```
Attribute       | Comment
----------      | ---------------------------------------------------------------------------------------------------------------------------------------------------
`scale`         | Used to resize `.stl` file, can be specified with units, or as a fraction(e.g. 1/100).
`Xrot,Yrot,Zrot`| Rotates geometry aroun X/Y/Z axis by given amount in degrees.
`x,y,z`         | Translates geometry along X/Y/Z axis  by given amount.  Distance can be specified in real-world units or number of grid points(without unit).
`side`          | Chose if geometry will be treated as wall, possible arguments: `"in"`,`"out"` 


##Symmetry

TODO:ustalić jak było z przesunięciem przy symetri, czy ma ona być na ostatnim elemencie ciała czy jedno za nim. 

##Synthetic Turbulence

A synthetic turbulence generator is implemented in TCLB solver. It is based on modified von Karman-Pao spectrum([Bailly and Juve, 1999](https://arc.aiaa.org/doi/10.2514/6.1999-1872)) 
```xml
<?xml version="1.0"?>
<CLBConfig version="2.0" output="output/test">
    <Units>
        <Params Velocity="1m/s" gauge="0.1"/>
        <Params Viscosity="0.01m2/s" gauge="0.01"/>
    </Units>
    <Geometry nx="128" ny="128" nz="128">
        <MRT><Box/></MRT>
        <WVelocityTurbulent name="Inlet"><Box nx="1"/></WVelocityTurbulent>
        <EPressure><Box dx="-1"/></EPressure>
        <Wall mask = "ALL">
            <Sphere dx="54" nx="20" dy="54" fy="74" dz="-74" nz="20"/>
        </Wall>
    </Geometry>
    <Model>
        <Params Velocity-Inlet="1m/s"
                nu="0.05m2/s"
                Turbulence="0.1m/s"
                MainWaveLength="10m"
                DiffusionWaveLength = "100m"/>
    </Model>
    <VTK Iterations="100" what = "U,P"/>
    <Solve Iterations="1000"/>
</CLBConfig>
```
It is important to remember that in order to use implemented turbulence generator it is required to change `WVelocity` to `WVelocityTurbulent`, e.g.: `<WVelocityTurbulent><Box nx="1"/></WVelocityTurbulent>`. The generator has more customizable attributes, given in table below, but most of them is not required for generator to work. Only the mandatory ones are provided in example above.



Attribute              | Comment 
---------------------- | ----------------------------------------------------------- 
`Modes`                | Number of harmonic modes to generate for the turbulence, default '100'.
`Spread`               | The way to divide the spectrum to a finite number of modes. Possible values: `Even`, `Log`, `Quantile`. Default is `Even`.
`Spectrum`             | Type of spectrum to use, possible values: `Von Karman`, `One Wave`. Default is `Von Karman`.
`MainWaveLength`       | Main wave-length in the Von Karman spectrum.
`DiffusionWaveLength`  | Diffusion scale wave-length in the Von Karman spectrum.
`MinWaveLength`        | Minimal space wave-length. TODO:Default value
`MaxWaveLength`        | Maximal space wave-length.
`TimeWaveLength`       | Time wave-length of the syntetic turbulence.
 
 It is possible to specify `WaveLength` parameters in terms of `WaveNumber` or `WaveFrequency`. 

