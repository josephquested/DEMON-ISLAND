using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Item : MonoBehaviour
{
    // -- SYSTEM -- //

    void Awake()
    {
        anim = GetComponent<Animator>();    
        aud = GetComponent<AudioSource>();
        ps = GetComponentInChildren<ParticleSystem>();
    }

    void Update()
    {
        
    }

    // -- PROJECTILES -- //

    [Header("PROJECTILES")]
    public Transform projectileSpawn;

    public GameObject projectilePrefab;
    public float projectileForce;

    public GameObject altProjectilePrefab;
    public float altProjectileForce;

    public void FireAltProjectile()
    {
        GameObject projectile = Instantiate(altProjectilePrefab, projectileSpawn.position, projectileSpawn.rotation);
        Rigidbody _rb = projectile.GetComponent<Rigidbody>();
        _rb.AddForce(projectileSpawn.up * altProjectileForce, ForceMode.Impulse);
    }

    public void FireProjectile()
    {

    }

    // -- INTERACTION -- //

    [Header("INTERACTION")]
    public Interaction interaction;
    public bool isFiring;
    public bool canAim;
    public bool isWeapon;

    public bool IsContinuious()
    {
        return interaction.continuiousInteraction;
    }

    // -- UI -- // 

    [Header("UI")]
    public Sprite icon;

    // -- ANIMATION -- //

    Animator anim;

    public void Equip()
    {
        anim.SetTrigger("Equip");
    }

    public void Unequip()
    {
        anim.SetTrigger("Unequip");
    }

    public void PlayFireAnimation()
    {
        isFiring = true;
        anim.SetTrigger("Fire");
    }
    
    public void PlayAltFireAnimation()
    {
        isFiring = true;
        anim.SetTrigger("AltFire");
    }

    public void StopFiring()
    {
        isFiring = false;

        if (ps != null)
            ps.Stop();
    }

    public void StartAiming()
    {
        anim.SetBool("Aiming", true);
        anim.SetTrigger("Aim");
    }

    public void StopAiming()
    {
        anim.SetBool("Aiming", false);
    }

    // -- AUDIO -- //

    [Header("AUDIO")]
    public AudioClip fireAudio;
    public AudioClip fireAltAudio;
    public AudioClip aimAudio;

    AudioSource aud;

    void FireAudio()
    {
        if (aud != null)
        {
            aud.clip = fireAudio;
            aud.pitch = Random.Range(0.9f, 1.1f);
            aud.Play();
        }
    }
    
    void FireAltAudio()
    {
        if (aud != null)
        {
            aud.clip = fireAltAudio;
            aud.pitch = Random.Range(0.9f, 1.1f);
            aud.Play();
        }
    }
        
    void AimAudio()
    {
        aud.clip = aimAudio;
        if (aud != null)
        {
            aud.pitch = Random.Range(0.9f, 1.1f);
            aud.Play();
        }
    }

    // -- PARTICLES -- //

    ParticleSystem ps;

    void FireParticles()
    {
        if (ps != null)
        {
            ps.Clear();
            ps.Play();
        }
    }
}
