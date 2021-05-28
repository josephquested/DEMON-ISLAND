using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RandomiseAudioPitch : MonoBehaviour
{
    public float minPitch;
    public float maxPitch;

    void Awake()
    {
        GetComponent<AudioSource>().pitch = Random.Range(minPitch, maxPitch);        
    }
}
