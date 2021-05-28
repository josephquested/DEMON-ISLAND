﻿using UnityEngine;
using System.Collections;

public class LightFlicker : MonoBehaviour
{

    // Your _light gameObject here.
    public Light _light;

    // Array of random values for the intensity.
    private float[] smoothing = new float[20];

    public float lightPower = 22;

    void Start()
    {
        _light = GetComponent<Light>();

        // Initialize the array.
        for (int i = 0; i < smoothing.Length; i++)
        {
            smoothing[i] = .0f;
        }
    }

    void Update()
    {
        float sum = .0f;

        // Shift values in the table so that the new one is at the
        // end and the older one is deleted.
        for (int i = 1; i < smoothing.Length; i++)
        {
            smoothing[i - 1] = smoothing[i];
            sum += smoothing[i - 1];
        }

        // Add the new value at the end of the array.
        smoothing[smoothing.Length - 1] = Random.value;
        sum += smoothing[smoothing.Length - 1];

        // Compute the average of the array and assign it to the
        // _light intensity.
        _light.intensity = sum / smoothing.Length * lightPower;
    }
}