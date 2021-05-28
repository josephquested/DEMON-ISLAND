using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Trigger_FirstDealerInteraction : MonoBehaviour
{
    // -- INTERACTION -- //

    [Header("INTERACTION")]
    public bool hasHadFirstInteraction = false;
    public Door mainRoomDoor;
    public Door bathRoomDoor;
    public Event_DealerRoomAudio lowcutDealerRoomAudioEvent;
    public Event_DealerRoomAudio dealerRoomAudioEvent;
    
    public GameObject firstConversationFlowchartObj;

    IEnumerator StartFirstInteractionRoutine()
    {
        hasHadFirstInteraction = true;
        mainRoomDoor.SystemUse();
        lowcutDealerRoomAudioEvent.Fire();
        dealerRoomAudioEvent.Fire();
        yield return new WaitForSeconds(1.5f);
        firstConversationFlowchartObj.SetActive(true);
    }

    // -- TRIGGER -- //


    void OnTriggerEnter(Collider other) 
    {
        if (other.tag == "Player")
        {
            if (!hasHadFirstInteraction)
                StartCoroutine(StartFirstInteractionRoutine());
        }    
    }
}


