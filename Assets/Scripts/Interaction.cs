using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public enum InteractionType { Use }

public class Interaction : MonoBehaviour
{

    // -- SYSTEM -- //

    void Start()
    {
        
    }

    void Update()
    {
        
    }

    // -- INTERACTION -- //

    [Header("INTERACTION")]
    public InteractionType type;
    public bool continuiousInteraction = false;
}
