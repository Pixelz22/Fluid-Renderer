using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode, ImageEffectAllowedInSceneView]
public class FluidRenderCamera : MonoBehaviour
{
    public Shader fluidRendererShader;
    public FluidData fluidData;
    public int numInScatteringSteps = 10;
    public int numOpticalDepthSteps = 5;
    public Vector3 wavelengths = new Vector3(700, 530, 440);
    public int scatteringType = 0;
    public float scatteringStrength = 1;


    private Material fluidRendererMat;

    private void Awake()
    {
        Camera.main.depthTextureMode = DepthTextureMode.Depth;
    }

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (fluidRendererMat == null) fluidRendererMat = new Material(fluidRendererShader);
        InitializeShader();

        Graphics.Blit(source, destination, fluidRendererMat);
    }

    private void InitializeShader()
    {

        // Set Renderer Properties
        fluidRendererMat.SetInteger("inScatteringSteps", numInScatteringSteps);
        fluidRendererMat.SetInteger("opticalDepthSteps", numOpticalDepthSteps);
        fluidRendererMat.SetVector("wavelengths", wavelengths);

        // Set container bounds
        fluidRendererMat.SetVector("BoundsMin", fluidData.transform.position - fluidData.transform.localScale / 2);
        fluidRendererMat.SetVector("BoundsMax", fluidData.transform.position + fluidData.transform.localScale / 2);

        // Set fluid properties
        fluidRendererMat.SetVector("ColorReflection", fluidData.colorReflection);
        fluidRendererMat.SetFloat("DensityMultiplier", fluidData.densityMultiplier);
        fluidRendererMat.SetVector("phaseParams", fluidData.getPhaseParams());
        fluidRendererMat.SetInteger("scatteringType", scatteringType);
        fluidRendererMat.SetFloat("scatteringStrength", scatteringStrength);
    }
}
