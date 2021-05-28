using System.Collections;
using System.Collections.Generic;
using UnityEngine;
public class Event_LeavingAfterFirstDealerConversation : MonoBehaviour, IEvent
{

    public GameObject lowcutDealerRoomAudioObj;
    public GameObject dancingActorsParent;
    public GameObject flashingRedLight;

    public void Fire() 
    {
        Destroy(lowcutDealerRoomAudioObj);
        Destroy(dancingActorsParent);
        Destroy(flashingRedLight);
    }
}
