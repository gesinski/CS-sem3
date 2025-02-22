using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GeneratedPlatforms : MonoBehaviour
{
    [SerializeField] GameObject platformPrefab;
    private const int PLATFORMS_NUM = 4;
    private GameObject[] platforms;

    private const float radius = 3.0f;
    private float[] angles; // Stores the current angle of each platform
    private const float rotationSpeed = 25.0f; // Degrees per second
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        for (int i = 0,j =0; i < PLATFORMS_NUM; i++, j+=10)
        {
            angles[i] += rotationSpeed * Time.deltaTime;

            // Ensure angles stay within 0-360 degrees to avoid overflow
            if (angles[i] >= 360f) angles[i] -= 360f;

            // Calculate new position in the circle using updated angle
            Vector2 newPosition = new Vector2(
                transform.position.x + radius * Mathf.Cos(angles[i] * Mathf.Deg2Rad),
                transform.position.y + radius * Mathf.Sin(angles[i] * Mathf.Deg2Rad)
            );

            // Update platform's position
            platforms[i].transform.position = new Vector3(newPosition.x, newPosition.y, platforms[i].transform.position.z);
        }
    }

    private void Awake()
    {
        platforms = new GameObject[PLATFORMS_NUM];
        angles = new float[PLATFORMS_NUM];

        for (int i = 0; i < PLATFORMS_NUM; i++)
        {
            // Calculate the initial angle for each platform
            angles[i] = (360f / PLATFORMS_NUM) * i;

            // Calculate initial position based on angle and radius
            Vector2 initialPosition = new Vector2(
                transform.position.x + radius * Mathf.Cos(angles[i] * Mathf.Deg2Rad),
                transform.position.y + radius * Mathf.Sin(angles[i] * Mathf.Deg2Rad)
            );

            // Instantiate platform at the calculated position
            platforms[i] = Instantiate(platformPrefab, initialPosition, Quaternion.identity);
        }

    }
}
