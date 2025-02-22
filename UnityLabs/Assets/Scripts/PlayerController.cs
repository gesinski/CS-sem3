using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using UnityEngine.SceneManagement;


public class PlayerController : MonoBehaviour
{
    [Header("Movement parameters")]
    [Range(0.01f, 20.0f)] [SerializeField] private float moveSpeed = 0.1f;
    [SerializeField]  private float jumpForce = 6.0f; [Space( 10 )]

    [Header("Audio")]
    [SerializeField] private AudioClip bSound;
    [SerializeField] private AudioClip keySound;
    [SerializeField] private AudioClip eSound;
    [SerializeField] private AudioClip victorySound;
    private AudioSource source;

    private Rigidbody2D rigidbody;
    private BoxCollider2D BoxCollider2D;
    public LayerMask groundLayer;
    const float rayLength = 1.5f;
    private Animator animator;
    private bool isWalking = false;
    private bool isFacingRight = true;
    private int score = 0;
    private bool isLadder = false;
    private bool isClimbing = false;
    private float vertical;
    public int lives = 3;
    private int keysFound = 0;
    private const int keysNumber = 3;
    private Vector2 startPosition;
    private Vector2 doorPos;
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        if (GameManager.instance.currentGameState == GameState.GAME) {
            isWalking = false;
            vertical = Input.GetAxis("Vertical");
            if (Input.GetKey(KeyCode.RightArrow) || Input.GetKey(KeyCode.D))
            {
                transform.Translate(moveSpeed * Time.deltaTime, 0.0f, 0.0f, Space.World);
                isWalking = true;
                if (!isFacingRight)
                {
                    Flip();
                }
            }
            if (Input.GetKey(KeyCode.LeftArrow) || Input.GetKey(KeyCode.A))
            {
                transform.Translate(moveSpeed * Time.deltaTime * -1.0f, 0.0f, 0.0f, Space.World);
                isWalking = true;
                if (isFacingRight)
                {
                    Flip();
                }
            }

            if (Input.GetKeyDown(KeyCode.Space))
            {
                Jump();
            }

            if (isLadder && Math.Abs(vertical) > 0)
            {
                isClimbing = true;
            }
            //Debug.DrawRay(transform.position, rayLength*Vector3.down, Color.white);

            animator.SetBool("isGrounded", IsGrounded());
            animator.SetBool("isWalking", isWalking);
            animator.SetBool("isClimbing", isClimbing);
        }
    }

    private void FixedUpdate()
    {
        if (isClimbing)
        {
            rigidbody.gravityScale = 0;
            rigidbody.velocity = new Vector2(rigidbody.velocity.x, vertical * moveSpeed);
        } else
        {
            rigidbody.gravityScale = 1;

        }
    }

    private void Awake()
    {
        BoxCollider2D = GetComponent<BoxCollider2D>();
        rigidbody = GetComponent<Rigidbody2D>();
        animator = GetComponent<Animator>();
        startPosition = transform.position;
        source = GetComponent<AudioSource>();
    }

    bool IsGrounded()
    {
        return Physics2D.Raycast(this.transform.position, Vector2.down, rayLength, groundLayer.value);
    }

    void Jump()
    {
        if (IsGrounded())
        {
            rigidbody.AddForce(Vector2.up * jumpForce, ForceMode2D.Impulse);
            Debug.Log("Jumping");
        }
    }
    private void Flip()
    {
        isFacingRight = !isFacingRight;
        Vector3 theScale = transform.localScale;
        theScale.x *= -1;
        transform.localScale = theScale;
    }

    private void OnTriggerEnter2D(Collider2D col)
    {
        if (col.tag == "FallLevel")
        {
            lives--;
            GameManager.instance.SubLives();
            if (lives == 0)
            {
                Debug.Log("Game Over");
                SceneManager.LoadScene(SceneManager.GetActiveScene().name);
            }
            else
            {
                Debug.Log(lives);
                transform.position = startPosition;
            }
            Debug.Log("Player fell into void");
        }
        if (col.CompareTag("Bonus"))
        {
            score++;
            GameManager.instance.AddPoints(score);
            source.PlayOneShot(bSound, AudioListener.volume);
            Debug.Log("Score: " + score);
            col.gameObject.SetActive(false);
        }
        if (col.CompareTag("Ladder"))
        {
            BoxCollider2D.size = new Vector3(0.9f, BoxCollider2D.size.y);
            isLadder = true;
        }
        if (col.CompareTag("Enemy"))
        {
            if (transform.position.y > col.gameObject.transform.position.y) {
                score++;
                GameManager.instance.AddPoints(score);
                GameManager.instance.AddEnemiesKilled();
                source.PlayOneShot(eSound, AudioListener.volume);
                Debug.Log("Killed an enemy");
            }
            else
            {
                lives--;
                GameManager.instance.SubLives();
                if (lives == 0)
                {
                    Debug.Log("Game Over");
                    SceneManager.LoadScene(SceneManager.GetActiveScene().name);
                }
                else
                {
                    Debug.Log(lives);
                    transform.position = startPosition;
                }
            }
        }
        if (col.CompareTag("Key"))
        {
            keysFound++;
            GameManager.instance.AddKeys();
            source.PlayOneShot(keySound, AudioListener.volume);
            col.gameObject.SetActive(false);
            Debug.Log("keysFound: " + keysFound);
        }
        if (col.CompareTag("Heart"))
        {
            lives++;
            GameManager.instance.AddLives();
            col.gameObject.SetActive(false);
            Debug.Log("Lives: "+ lives);
        }
        if (col.CompareTag("Finish"))
        {
            if (keysFound == 3)
            {
                source.PlayOneShot(victorySound, AudioListener.volume);
                score = 100 * lives;
                GameManager.instance.AddPoints(score);
                GameManager.instance.GameOver();
                Debug.Log("Finished");
            } else
            {
                Debug.Log("Not enough keys");
            }
        }
        if (col.CompareTag("MovingPlatform"))
        {
            transform.SetParent(col.transform);
        }
        if (col.CompareTag("Doors"))
        {
            doorPos = new Vector2(10.0f, -5.0f);
            transform.position = doorPos;
        }
    }

    private void OnTriggerExit2D(Collider2D col)
    {
        if (col.CompareTag("Ladder"))
        {
            BoxCollider2D.size = new Vector3(1.12f, BoxCollider2D.size.y);
            isLadder = false;
            isClimbing = false;
        }
        if (col.CompareTag("MovingPlatform"))
        {
            transform.SetParent(null);
        }
    }
}
