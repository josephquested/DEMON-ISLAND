using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class UIController : MonoBehaviour
{
    // -- UI CONTROL -- //

    public UIInventorySlot[] inventorySlots;

    public GameObject interactionParent;
    public Text interactionText;

    public Sprite blankSprite;

    float hideTimer = 5f;

    bool isHidden = true;

    void FixedUpdate()
    {
        if (!isHidden)
        {
            hideTimer -= Time.fixedDeltaTime;

            if (hideTimer <= 0)
            {
                inventoryAnimator.Play("Hide");
                isHidden = true;
            }
        }
    }

    public void ShowInventory()
    {
        if (isHidden)
        {
            inventoryAnimator.Play("Show");
            isHidden = false;
            hideTimer = 3f;
        }
        else
        {
            hideTimer = 3f;
        }
    }

    public Animator inventoryAnimator;

    public void EnableInteractionText(bool state, string _interactionText) 
    {
        interactionParent.SetActive(state);
        interactionText.text = _interactionText;
    }

    public void UpdateSelectedSlot(int slotIndex)
    {
        int i = 0;

        foreach(UIInventorySlot slot in inventorySlots)
        {
            bool isSelected = i == slotIndex;
            slot.SetSelected(isSelected);            
            i++;
        }
    }

    public void UpdateInventorySlots(List<int> itemQuantities)
    {
        int i = 0;

        foreach(UIInventorySlot slot in inventorySlots)
        {
            int quantity = itemQuantities[i];

            slot.quantityText.text = quantity.ToString();

                if (quantity > 0)
                {
                    slot.SetIconTransparent(false);
                }
                else 
                {
                    slot.SetIconTransparent(true);
                }

                i++;
        }
    }
}