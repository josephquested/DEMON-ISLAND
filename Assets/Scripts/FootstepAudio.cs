using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FootstepAudio : MonoBehaviour
{
    // -- SYSTEM -- //

    void Awake()
    {
        aud = GetComponent<AudioSource>();
    }

    // -- AUDIO -- //

    public AudioClip[] dritAudioClips;

    AudioSource aud;
    bool leftFoot;

    public void PlayFootstep(bool isRunning)
    {
        if (isRunning)
            aud.pitch = Random.Range(1.1f, 1.3f);
        else
            aud.pitch = Random.Range(0.7f, 1f);

        if (leftFoot)
            aud.PlayOneShot(dritAudioClips[0]);
        else
            aud.PlayOneShot(dritAudioClips[1]);

        leftFoot = !leftFoot;
    }
}
