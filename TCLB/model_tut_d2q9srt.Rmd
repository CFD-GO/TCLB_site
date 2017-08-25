---
title: "D2Q9 Single Relexation Time"
author: "Travis Mitchell"
date: "May 30, 2016"
output: html_document
---
This tutorial will try to teach you how to make and use lattice Boltzmann (LB) models within the TCLB environment. First a brief overview will be given of the discrete [lattice Boltzmann equation](https://en.wikipedia.org/wiki/Lattice_Boltzmann_methods) taking advantage of the Bhatnagar-Gross-Krook (BGK) collision operator (also known as single relaxation time operator) will be given, then the code required to simulate Poiseuille flow will be developed.

## The BGK-lattice Boltzmann Equation
The discrete form of the Boltzmann transport equation can be expressed as:

$f_i(x+c_i,t+1)=f_i(x,t)-\frac{1}{\tau}(f_i(x,t)-f_i^{eq}(x,t))$

This describes the evolution of particle distribution functions along discrete velocities, where the right hand side is often referred to as the collision operation and the evaluation to the left hand side, the streaming operation. Note here that we are going to work in lattice units during the description of the model in which we assume $\Delta x = \Delta t = 1$. For the D2Q9 model, this assumption allows us to express the 9 discrete directions as,

$c = \left( \begin{array}& 0 & 1 & 0 & -1 & 0 & 1 & -1 & -1 & 1 \\ 0 & 0 & 1 & 0 & -1 & 1 & 1 & -1 & -1 \end{array} \right)$ 

Additionally, we define the equilibrium distribution function found by an expansion of a Maxwellian distribution as,

$f_i^{eq}(x,t) = \omega _ i \rho \left( 1 + \frac{c_iu}{c_s^2}+ \frac{(c_iu)^2}{2c_s^4} - \frac{u^2}{2c_s^2} \right)$

where,

$c_s^2 = \frac{1}{3}$


$\omega_i=\left\{ \begin{array}{ll}  \frac{4}{9}  & i=0\\ \frac{1}{9} & i=1,2,3,4\\ \frac{1}{36} & i=5,6,7,8 \end{array} \right.$
              
### Boundary Conditions and Force Implementation

For this specific example, we are looking at a flow through a channel. We can utilise periodic conditions along the x-axis but have to implement no-slip wall conditions to limit  domain along y-axis. To do this with LBM, the bounceback method is used.  Particle distribution functions that stream into a node flagged as a "wall" are reversed, or "bounced-back" in the opposite direction Therefore, in general for a D2Q9 lattice we obtain,

$\left\{ \begin{array}{ll}   f_0=f'_0\\ f_1=f'_3\\ f_2=f'_4\\ f_3=f'_1\\ f_4=f'_2\\ f_5=f'_7\\ f_6=f'_8\\ f_7=f'_5\\ f_8=f'_6\\  \end{array} \right.$

where ' indicates the post-bounce-back direction.

To drive the fluid in the Poiseuille flow example, a body force will be applied. For this we consider a body force **G** acting in each time increment resulting in a momentum change $\Delta\rho u = G$ . To incorporate this, we modify the equilibrium velocity,

$\rho u^* = \rho u + \tau G$

This approach ultimately acts to relax each particle distribution function towards an equilibrium momentum that has included the time-incremental change due to the applied body force. To obtain the bulk fluid velocity, the before and after collision momentum is averaged giving,

$\rho v = \rho u + \frac{1}{2} G$

and with this we now have all we the dynamics required to implement the specified example.

## Model Creation in TCLB

As in the previous [tutorial](TODO:podlinkować fdwave), we want to set up a folder named `d2q9srt` in  `~TCLB/models/tutorial/` and create the generic file structure (`conf.mk`, `Dynamics.c`, `Dynamics.R`).

To start off the model, we look to add the nine distribution functions for the nine discrete velocities. This is implemented in the `Dynamics.R` file, but instead of adding each as its own field we look to stream the functions in the process of calling them at each node. To do this we instead add them as [Densities](TODO:podlinkować):
```R
AddDensity(name="f[0]", dx=0, dy=0  )
AddDensity(name="f[1]", dx=1, dy=0  )
AddDensity(name="f[2]", dx=0, dy=1  )
AddDensity(name="f[3]", dx=-1,dy=0  )
AddDensity(name="f[4]", dx=0, dy=-1 )
AddDensity(name="f[5]", dx=1, dy=1  )
AddDensity(name="f[6]", dx=-1,dy=1  )
AddDensity(name="f[7]", dx=-1,dy=-1 )
AddDensity(name="f[8]", dx=1, dy=-1 )
```
Notice that the dx and dy coordinates correspond with the **c** matrix previously given. At this stage, it helps to assess what other values will be  needed to initialise and run the LBM. To start off the method, a fluid density and initial velocities must be specified, then to perform the collision operation the relaxation time  and the magnitude of the applied body force need to be defined . Additionally, from this simulation we want to be able to interrogate the macroscopic fluid velocity and density so these must be added as [Quantities](TODO:link).  For this, we define (in `Dynamics.R`):

```R
AddQuantity( name="U",unit="m/s", vector=TRUE )
AddQuantity( name="Rho",unit="kg/m3" )

AddSetting( name="omega", comment='inverse of relaxation time')
AddSetting( name="nu", omega='1.0/(3*nu+0.5)', default=0.16666666, comment='viscosity')
AddSetting( name="Velocity",default=0, comment='inlet/outlet/init velocity', zonal=TRUE)
AddSetting( name="GravitationX",default=0, comment='body/external acceleration', zonal=TRUE)
AddSetting( name="GravitationY",default=0, comment='body/external acceleration', zonal=TRUE)
AddSetting( name="Density",default=1, comment='Density')
```
From the above, we have all the variables we need to implement the LBM. The first step is to initialise the lattice over the required domain, this is incorporated as part of the dynamics that are occurring in the model and must be incorporated into the `Dynamics.c` file within the `Init()` function.
```c
CudaDeviceFunction void Init(){
    real_t u[2] = {Velocity, 0.0};
    real_t d = Density;
    SetEquilibrium(d,u);
}
```
Notice here that we are calling on the function `SetEquilibrium()` within which we want to calculate the equilibrium distribution $f_i^{eq}$ for the given density and velocity fields.

```c
CudaDeviceFunction void SetEquilibrium(real_t d, real_t u[2])
{
f[0] = ( 2. + ( -u[1]*u[1] - u[0]*u[0] )*3. )*d*2./9.;
f[1] = ( 2. + ( -u[1]*u[1] + ( 1 + u[0] )*u[0]*2. )*3. )*d/18.;
f[2] = ( 2. + ( -u[0]*u[0] + ( 1 + u[1] )*u[1]*2. )*3. )*d/18.;
f[3] = ( 2. + ( -u[1]*u[1] + ( -1 + u[0] )*u[0]*2. )*3. )*d/18.;
f[4] = ( 2. + ( -u[0]*u[0] + ( -1 + u[1] )*u[1]*2. )*3. )*d/18.;
f[5] = ( 1. + ( ( 1 + u[1] )*u[1] + ( 1 + u[0] + u[1]*3. )*u[0] )*3. )*d/36.;
f[6] = ( 1. + ( ( 1 + u[1] )*u[1] + ( -1 + u[0] - u[1]*3. )*u[0] )*3. )*d/36.;
f[7] = ( 1. + ( ( -1 + u[1] )*u[1] + ( -1 + u[0] + u[1]*3. )*u[0] )*3. )*d/36.;
f[8] = ( 1. + ( ( -1 + u[1] )*u[1] + ( 1 + u[0] - u[1]*3. )*u[0] )*3. )*d/36.;
}
```
With the equilibrium function taken care of, we can now look at updating our initialised lattice. For this, the streaming operation is taken care of with the specification of [Densities](TODO:podlinkować) that we made. The collision operation however needs to be implemented and bounce-back for nodes flagged as walls. To do this, we define the `run()` function to describe what happens at each node at each timestep.

```c
CudaDeviceFunction void Run() {
// This defines the dynamics that we run at each node in the domain.
    switch (NodeType & NODE_BOUNDARY) {
	case NODE_Wall:
		BounceBack();
		break;
    }
	if ((NodeType & NODE_BOUNDARY) == NODE_BGK) 
	{
		CollisionBGK();
	}
}
```
**Don't forget to declare new node types in `Dynamics.R`.**

Additionally, in all `Dynamics.c` files the `Color()` function is required. (even with `./configure --disable-graphics`).

```c
CudaDeviceFunction float2 Color() {
  float2 ret;
  ret.x = 0;
  ret.y = 1;
  return ret;
}
```

The switch function described can also be used for the implementation of velocity/pressure boundaries, but these will not be discussed in this tutorial. As can be seen above, we need to define functions that describe both the `BounceBack()` and `CollisionBGK()` operations. The bounce-back operation occurs as described in the theory component of this tutorial where distribution functions are reversed:
```c
CudaDeviceFunction void BounceBack() {
// Method to reverse distribution functions along the bounding nodes.
     	real_t uf;
	uf = f[3];
	f[3] = f[1];
	f[1] = uf;
	uf = f[4];
	f[4] = f[2];
	f[2] = uf;
	uf = f[7];
	f[7] = f[5];
	f[5] = uf;
	uf = f[8];
	f[8] = f[6];
	f[6] = uf;
}
```
The BGK collision, from the left hand side of the discrete Boltzmann equation:

```c
CudaDeviceFunction void CollisionBGK() {
// Here we perform a single relaxation time collision operation.
// We save memory here by using a single dummy variable
	real_t u[2], d, f_temp[9];
	d = getRho();
	// pu* = pu + rG
	u[0] = (( f[8]-f[7]-f[6]+f[5]-f[3]+f[1] )/d + GravitationX/omega );
	u[1] = ((-f[8]-f[7]+f[6]+f[5]-f[4]+f[2] )/d + GravitationY/omega );
	f_temp[0] = f[0];
	f_temp[1] = f[1];
	f_temp[2] = f[2];
	f_temp[3] = f[3];
	f_temp[4] = f[4];
	f_temp[5] = f[5];
	f_temp[6] = f[6];
	f_temp[7] = f[7];
	f_temp[8] = f[8];
	SetEquilibrium(d, u); //stores equilibrium distribution in f[0]-f[8]
	f[0] = f_temp[0] - omega*(f_temp[0]-f[0]);	
	f[1] = f_temp[1] - omega*(f_temp[1]-f[1]);
	f[2] = f_temp[2] - omega*(f_temp[2]-f[2]);
	f[3] = f_temp[3] - omega*(f_temp[3]-f[3]);	
	f[4] = f_temp[4] - omega*(f_temp[4]-f[4]);
	f[5] = f_temp[5] - omega*(f_temp[5]-f[5]);
	f[6] = f_temp[6] - omega*(f_temp[6]-f[6]);	
	f[7] = f_temp[7] - omega*(f_temp[7]-f[7]);
	f[8] = f_temp[8] - omega*(f_temp[8]-f[8]);
}
```
With all the dynamics described, all that is left to do now is calculate the macroscopic variables using `Get` functions to correspond with the Quantities stated in `Dynamics.R`.The macroscopic density is the sum of all the distribution functions and the momentum is the sum of the distribution functions multiplied by the discrete velocity directions.

```c
CudaDeviceFunction real_t getRho() {
// This function defines the macroscopic density at the current node.
	return f[8]+f[7]+f[6]+f[5]+f[4]+f[3]+f[2]+f[1]+f[0];
}

CudaDeviceFunction vector_t getU() {
// This function defines the macroscopic velocity at the current node.
	real_t d = f[8]+f[7]+f[6]+f[5]+f[4]+f[3]+f[2]+f[1]+f[0];
	vector_t u;
	// pv = pu + G/2
	u.x = (( f[8]-f[7]-f[6]+f[5]-f[3]+f[1] )/d + GravitationX*0.5 );
	u.y = ((-f[8]-f[7]+f[6]+f[5]-f[4]+f[2] )/d + GravitationY*0.5 );
	u.z = 0;
	return u;
}
```

##Setting up a Simulation

In order validate this example, we want to specify the relation between physical and lattice units. For this, we need provide the relations for the spatial and time dimensions. The most natural way to do this is to give the physical `dx` size and the actual fluid viscosity. This information is stored at the start of the `xml` input file under the parent heading of `<Units>`, for this you want to first create a new file by the name of `d2q9_poiseuille.xml`:

```xml
<?xml version="1.0"?>
<CLBConfig version="2.0" output="output/">
	<Units>
		<Params size="0.0005m" gauge="1"/>
		<Params nu="1e-5m2/s" gauge="0.1666666666"/>
	</Units>
```

The reason for this, is it gives not only a view of how to implement physical values in TCLB but gives a straightforward method to calculate the expected maximum physical velocity. We do this through a comparison of the maximum velocity which in Poiseuille is given by:

$u_{max} = \frac{gH^2}{8\nu}$

The setup of the test simulation domain is arbitrary and different values can be tested from those shown here. A channel of `0.02m` length and `0.0095m` height is chosen with an applied body force of `0.000311634m/s^2`. As stated above one lattice spacing is equal to `0.0005m` so the total size of the simulation domain will be `0.02 x (0.0095+2*0.0005) m`. This is defined as the geometry of the system in the xml set up file noting that the in-built `<Channel>` function is used to specify the bottom and top nodes as walls:
```xml
<Geometry nx="0.02m" ny="0.0105m">
	<BGK><Box/></BGK>
	<Wall mask="ALL">
		<Channel/>
	</Wall>
</Geometry>
```
Here we can see that the collision method specified for the cells in the entire domain is BGK to align with the `Run` function. Following on from the geometry of the domain, the model specific settings (defined in `Dynamics.R`) need to be defined. For this we take a fluid of density `1000kg/m^3` and choose a relaxation time of the value 1.

```xml
<Model>
	<Params Velocity="0.0"/>
	<Params omega="1.0"/>
	<Params GravitationX="0.000311634m/s2"/>
	<Params Density="1000kg/m3"/>
</Model>
```
The final step is to output the desired quantities both at the start (so we can be sure that we have initialised the lattice correctly) and after the final solution step.

```xml
	<VTK/>
	<VTK Iterations="50000"/>
	<Solve Iterations="50000"/>
</CLBConfig>
```
With the model and set-up files created, we can now look to make and run d2q9srt. To do this first enter the TCLB directory and call the run file along with the input file location, after this, the analysis can be performed in Paraview:

```bash
make d2q9srt
CLB/d2q9srt/main d2q9_poiseuille.xml
paraview output/d2q9_poiseuille_VTK_P00_..pvti
```
In case the calculations are run on CPU, an mpi run can also be initiated e.g:

```bash
mpirun -np 4 CLB/d2q9srt/main d2q9_poiseuille.xml
```

From the analytical equation given before, we expect a maximum velocity of `0.000351562m/s`, while in the results it is found to be `0.00035293m/s` showing an error of 0.389%.

