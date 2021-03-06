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

    public void HideInventory()
    {
        hideTimer = 0f;
        inventoryAnimator.Play("Hide");
        isHidden = true;
    }

    public GameObject selectedItemObj;

    public Animator inventoryAnimator;

    public void EnableInteractionText(bool state, string _interactionText) 
    {
        interactionParent.SetActive(state);
        interactionText.text = _interactionText;
    }

    public void SetSlotSelected(int slotIndex)
    {
        selectedItemObj.transform.SetParent(inventorySlots[slotIndex].gameObject.transform);
        selectedItemObj.transform.position = inventorySlots[slotIndex].gameObject.transform.position;
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

    // -- crafting -- //
    
    public Animator craftingAnim;

    public Text craftingText;
    public Text craftingText2;

    public void DisplayCraftingMessage(string message)
    {
        StartCoroutine(MessageRoutine(message));
    }

    IEnumerator MessageRoutine(string message)
    {
        craftingText.text = message;
        craftingText2.text = message;
        yield return new WaitForSeconds(2);
        craftingText.text = "CRAFTING";
        craftingText2.text = "CRAFTING";
    }

    public void HideCraftingMenu(bool state)
    {
        if (state == true)
        {
            craftingAnim.Play("Hide");
        }

        else
        {
            craftingAnim.Play("Show");
        }
    }

}