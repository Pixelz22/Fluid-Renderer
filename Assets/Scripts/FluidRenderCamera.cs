using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode, ImageEffectAllowedInSceneView]
public class FluidRenderCamera : MonoBehaviour
{
    public Shader fluidRendererShader;
    public Transform container;


    private Material fluidRendererMat;

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        InitializeShader();

        Graphics.Blit(source, destination, fluidRendererMat);
    }

    private void InitializeShader()
    {
        if (fluidRendererMat == null) fluidRendererMat = new Material(fluidRendererShader);

        // Set container bounds
        fluidRendererMat.SetVector("BoundsMin", container.position - container.localScale / 2);
        fluidRendererMat.SetVector("BoundsMax", container.position + container.localScale / 2);
    }
}
