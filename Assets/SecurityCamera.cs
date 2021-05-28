using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SecurityCamera : MonoBehaviour
{

    // -- SYSTEM -- //

    AudioSource aud;
    Transform playerTrans;
    public float beepDelay;
    public float distance;

    void Start()
    {
        playerTrans = GameObject.FindWithTag("Player").transform;
        aud = GetComponent<AudioSource>();
        StartCoroutine(BeepRoutine());
    }

    void Update() 
    {
        distance = Vector3.Distance (transform.position, playerTrans.position);
    }

    IEnumerator BeepRoutine()
    {
        float _beepDelay = beepDelay;

        if (distance < 5)
            _beepDelay = 0.6f;
        if (distance < 4)
            _beepDelay = 0.3f;
        if (distance < 3)
            _beepDelay = 0.2f;
        if (distance < 2)
            _beepDelay = 0.1f;

        yield return new WaitForSeconds(_beepDelay);
        aud.Play();
        StartCoroutine(BeepRoutine());
    }
}
