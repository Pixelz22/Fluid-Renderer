using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode, ImageEffectAllowedInSceneView]
public class FluidRenderCamera : MonoBehaviour
{
    public Shader fluidRendererShader;
    public FluidData fluidData;
    public int numSteps = 1;


    private Material fluidRendererMat;

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (fluidRendererMat == null) fluidRendererMat = new Material(fluidRendererShader);
        InitializeShader();

        Graphics.Blit(source, destination, fluidRendererMat);
    }

    private void InitializeShader()
    {

        // Set Renderer Properties
        fluidRendererMat.SetInteger("inScatteringSteps", numSteps);

        // Set container bounds
        fluidRendererMat.SetVector("BoundsMin", fluidData.transform.position - fluidData.transform.localScale / 2);
        fluidRendererMat.SetVector("BoundsMax", fluidData.transform.position + fluidData.transform.localScale / 2);

        // Set fluid properties
        fluidRendererMat.SetVector("ColorReflection", fluidData.colorReflection);
        fluidRendererMat.SetFloat("DensityMultiplier", fluidData.densityMultiplier);
    }
}
