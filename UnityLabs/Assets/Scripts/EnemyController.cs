using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SocialPlatforms.Impl;

public class EnemyController : MonoBehaviour
{
    [Range(0.01f, 20.0f)] [SerializeField] private float moveSpeed = 0.1f;
    [SerializeField] private float moveRange = 0.1f;
    private Animator animator;
    private float startPositionX;
    private bool isFacingRight = false;
    private bool isMovingRight = false;
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        if (isMovingRight)
        {
            if (this.transform.position.x < startPositionX + moveRange)
            {
                moveRight();
            } else
            {
                isMovingRight = !isMovingRight;
                Flip();
                moveLeft();
            }
        } else
        {
            if (this.transform.position.x > startPositionX - moveRange)
            {
                moveLeft();
            } else
            {
                isMovingRight = !isMovingRight;
                Flip();
                moveRight();
            }
        }
    }

    private void moveRight()
    {
        transform.Translate(moveSpeed * Time.deltaTime, 0.0f, 0.0f, Space.World);
        //if (!isFacingRight)
        //{
        //    Flip();
        //}
    }

    private void moveLeft()
    {
        transform.Translate(moveSpeed * Time.deltaTime * -1.0f, 0.0f, 0.0f, Space.World);
        //if (isFacingRight)
        //{
        //    Flip();
        //}
    }

    private void Flip()
    {
        isFacingRight = !isFacingRight;
        Vector3 theScale = transform.localScale;
        theScale.x *= -1;
        transform.localScale = theScale;
    }
    private void Awake()
    {
        startPositionX = this.transform.position.x;

        //rigidbody = GetComponent<Rigidbody2D>();
        animator = GetComponent<Animator>();
    }

    private void OnTriggerEnter2D(Collider2D col)
    {
        
        if (col.CompareTag("Player"))
        {
            if (transform.position.y < col.gameObject.transform.position.y)
            {
                animator.SetBool("isDead", true);
                StartCoroutine(KillOnAnimationEnd());
            }
        }
    }

    IEnumerator KillOnAnimationEnd()
    {
        yield return new WaitForSeconds(1);
        gameObject.SetActive(false);
    }
}
