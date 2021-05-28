using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Event_DealerRoomAudio : MonoBehaviour, IEvent
{
    public AudioSource roomAudio;

    public void Fire() 
    {
        roomAudio.enabled = !roomAudio.enabled;
    }
}
