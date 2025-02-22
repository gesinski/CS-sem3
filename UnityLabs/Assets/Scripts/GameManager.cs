using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;
using System;
using TMPro;

public enum GameState {GAME, PAUSE_MENU, LEVEL_COMPLETED, OPTIONS}
public class GameManager : MonoBehaviour
{
    public GameState currentGameState = GameState.GAME;
    public static GameManager instance;
    public Canvas inGameCanvas = null;
    private int score = 0;
    public TMP_Text scoreText;
    public TMP_Text scoreText2;
    public TMP_Text highScoreText;
    public Image[] keysTab;
    private int keysFound = 0;
    public Image[] livesTab;
    private int Lives = 3;
    public TMP_Text timerText;
    public TMP_Text qualityText;
    private float elapsedTime = 0.0f;
    public TMP_Text enemiesKilledText;
    private int enemiesKilled = 0;
    public Canvas pauseMenuCanvas;
    public Canvas levelCompletedCanvas;
    public Canvas optionsCanvas;
    const string keyHighScore = "HighScoreLevel1";

    // Start is called before the first frame update
    void Start()
    {
        
    }

    private void Awake()
    {
        InGame();
        if (instance == null)
        {
            instance = this;
        }else
        {
            Debug.LogError("Duplicated Game Manager", gameObject);
        }
        scoreText.text = "00";
        qualityText.text = "Quality: " + QualitySettings.GetQualityLevel();
        livesTab[3].enabled = false;
        for (int i = 0; i < 3; i++)
        {
            keysTab[i].color = Color.grey;
        }
        if (PlayerPrefs.HasKey(keyHighScore) == false)
        {
            PlayerPrefs.SetInt(keyHighScore, 0);
        }
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Escape))
        {
           if (currentGameState == GameState.GAME)
            {
                SetGameState(GameState.PAUSE_MENU);
                PauseMenu();
            }else if (currentGameState == GameState.PAUSE_MENU)
            {
                SetGameState(GameState.GAME);
                InGame();
            }
           else if (currentGameState == GameState.OPTIONS)
            {
                SetGameState(GameState.GAME);
                InGame();
            }
        }

        elapsedTime += Time.deltaTime;

        int minutes = Mathf.FloorToInt(elapsedTime / 60);
        int seconds = Mathf.FloorToInt(elapsedTime % 60); 

        string formattedTime = string.Format("{0:00}:{1:00}", minutes, seconds);

        timerText.text = formattedTime;

    }

    void SetGameState(GameState newGameState)
    {
        currentGameState = newGameState;
        pauseMenuCanvas.enabled = (currentGameState == GameState.PAUSE_MENU);
        levelCompletedCanvas.enabled = (currentGameState == GameState.LEVEL_COMPLETED);
        optionsCanvas.enabled = (currentGameState == GameState.OPTIONS);
        if (currentGameState == GameState.GAME)
        {
            inGameCanvas.enabled = true;
            Debug.Log("CanvasOdpalone");
        }
        else if (currentGameState == GameState.LEVEL_COMPLETED)
        {
            Scene currentScene = SceneManager.GetActiveScene();
            if (currentScene.name == "Level1")
            {
                int highScore = PlayerPrefs.GetInt(keyHighScore);
                if (highScore < score)
                {
                    highScore = score;
                    PlayerPrefs.SetInt(keyHighScore, score);
                }
                highScoreText.text = "Best score: " + highScore.ToString();
            }
        }
    }

    public void AddEnemiesKilled()
    {
        enemiesKilled++;
        if (enemiesKilled < 10)
        {
            enemiesKilledText.text = "0" + enemiesKilled.ToString();
        }
        else
        {
            enemiesKilledText.text = enemiesKilled.ToString();
        }
    }

    public void SubLives()
    {
        Lives--;
        livesTab[Lives].enabled = false;
    }

    public void AddLives()
    {
        Lives++;
        livesTab[Lives-1].enabled = true;
    }

    public void AddKeys()
    {
        keysFound++;
        keysTab[keysFound-1].color = Color.red;
    }

    public void AddPoints(int points)
    {
        score = points;
        scoreText2.text = "Your score: " + points.ToString();
        if (points < 10)
        {
            scoreText.text = "0" + points.ToString();
        }
        else
        {
            scoreText.text = points.ToString();
        }
        
    }

    public void PauseMenu()
    {
        SetGameState(GameState.PAUSE_MENU);
        Time.timeScale = 0;
    }

    public void InGame()
    {
        SetGameState(GameState.GAME);
        Time.timeScale = 1;
    }

    public void GameOver()
    {
        SetGameState(GameState.LEVEL_COMPLETED);
    }

    public void OnResumeButtonClicked()
    {
        InGame();
    }

    public void OnRestartButtonClick()
    {
        SceneManager.LoadScene(SceneManager.GetActiveScene().name);
    }

    public void OnReturnButtonClicked()
    {
        SceneManager.LoadScene("MainMenu");
    }

    public void Options()
    {
        SetGameState(GameState.OPTIONS);
        Time.timeScale = 0;
    }

    public void SetVolume(float vol)
    {
        AudioListener.volume = vol;
        Debug.Log(vol);
    }

    public void IncreaseQuality()
    {
        QualitySettings.IncreaseLevel();
        qualityText.text = "Quality: " + QualitySettings.GetQualityLevel();

    }

    public void DecreaseQuality()
    {
        QualitySettings.DecreaseLevel();
        qualityText.text = "Quality: " + QualitySettings.GetQualityLevel();
    }
}
