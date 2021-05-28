using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Halflife : MonoBehaviour
{
    public float halflife;

    void Start()
    {
        Destroy(gameObject, halflife);
    }
}
