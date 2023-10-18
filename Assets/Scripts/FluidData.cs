using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FluidData : MonoBehaviour
{
    [Header("Density")]
    public float densityMultiplier = 1f;

    [Header("Lighting")]
    public Color colorReflection = Color.white;
    [Range(0, 1)]
    public float forwardScattering = .83f;
    [Range(0, 1)]
    public float backScattering = .3f;
    [Range(0, 1)]
    public float baseBrightness = .8f;
    [Range(0, 1)]
    public float phaseFactor = .15f;

    public Vector4 getPhaseParams()
    {
        return new Vector4(forwardScattering, backScattering, baseBrightness, phaseFactor);
    }
}
