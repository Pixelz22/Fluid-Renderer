# Fluid Renderer
The goal of this project is to create a physics-based screen-space rendering algorithm for general fluids. This renderer should be highly customizable to work for any sort of fluid, including but not limited to atmospheric gas, clouds, water, and other liquids. I'm aiming to make this easily mesh with any sort of fluid simulation by only requiring a density function to sample the density of the fluid at any point. Everything else gets handled by the renderer. Hopefully, this is fast enough to handle rendering multiple fluids at once. So far this has worked great for gases, but liquids are proving to be more difficult.

## Tasks
- ~~Get Shader skeleton up~~
- ~~Optical Depth function~~
- ~~Beer-Lambert Law~~
- ~~Basic In-Scattering~~
- ~~Weighting In-Scattered light by its angle relative to the view ray~~
- Figure out how phase weight function works
- Add option for switching between Rayleigh and Mie scattering
- Allow multiple fluids to be rendered at once
- Research water/liquid renderers
