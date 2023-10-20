# Fluid Renderer
The goal of this project is to create a physics-based screen-space rendering algorithm for general fluids. This renderer should be highly customizable to work for any sort of fluid, including but not limited to atmospheric gas, clouds, water, and other liquids. I'm aiming to make this easily mesh with any sort of fluid simulation by only requiring a density function to sample the density of the fluid at any point. Everything else gets handled by the renderer. Hopefully, this is fast enough to handle rendering multiple fluids at once. So far this has worked great for gases, but liquids are proving to be more difficult.

## Tasks
- ~~Get Shader skeleton up~~
- ~~Optical Depth function~~
- ~~Beer-Lambert Law~~
- ~~Basic In-Scattering~~
- ~~Weighting In-Scattered light by its angle relative to the view ray~~
- Figure out how phase weight function works
- ~~Add option for switching between Rayleigh and Mie scattering~~
- Allow multiple fluids to be rendered at once
- Research water/liquid renderers

## Strategy and Implementation

So far I've based the rendering strategy off of this general fluid lighting equation that I've derived from my own personal logic and looking at other people's code. Is it a sloppy use of notation and vaguely defined in some places? Definitely (Though I hope to make it less so in the future). Is it physically accurate? Who knows! :D

<p align="center">
<img src="README-Pics/fluidLightingEquation2.png" alt="Self-derived Fluid Lighting Equation" style="width: 40em;"/>
</p>

This might seem overly complicated, but it actually makes rendering the fluids easier in screen space. The background color can be taken directly from the screen for all view rays coming from the camera. This gets the majority of the work done. The other bit of the integral is referred to as the in-scattered light along the view ray. We can compute this with a numerical integral approach. Instead of sampling all rays at each in-scatter point, we'll just sample the ones going directly towards the light source, since those we'll have the most influence. Unfortunately, when the view ray goes directly into the sun, this ends up sampling the the same light twice, but it's almost unnoticable.

One thing interesting, according to the base form of the equation, moving across a fluid with 0 density would result in the incoming light being the background light multiplied by distance along the view ray. This looks absolutely horrible in the shader though, so you'd think that the actual equation needs to be divide by the total distance. But when I divide the in-scattered light by the distance, it looked really strange. So yea, I'm kinda puzzled about this.
