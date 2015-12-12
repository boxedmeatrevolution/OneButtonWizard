class InputProcessor {
  
  float DOT_TIME = 0.25f, DASH_TIME = 0.5, PAUSE_TIME = 0.5f;
  
  char _keyToProcess;
  ArrayList<InputType> _inputWord;
    
  ArrayList<ArrayList<InputType>> _processedWords;
  
  InputState _inputState;
  float _stateTmer;
  
  boolean _keyDown;
  
  InputProcessor (char keyToProcess) {
    _keyToProcess = keyToProcess;
    _inputWord = new ArrayList<InputType>();
    _inputWord = new ArrayList<ArrayList<InputType>>();
    _lastDown = _LastUp = 0;
    _inputState = WAITIING_TO_START;
    _stateTimer = 0;
    _keyDown = false;
  }
  
  void keyPressed() {
    if(key == _keyToProcess) {
      _keyDown = true;
    }
  }
  
  void keyReleased() {
    if(key == _keyToProcess) {
      _keyDown = false;
    }
  }
  
  void update (float deltaTime) {
    if (_inputState == WAITING_TO_START) {
      if (_keyDown) {
        _inputState = WAITING_FOR_KEY_UP;
        _stateTimer = 0;
        _inputWord.clear();
      }
    } else if (_inputState == WAITING_FOR_KEY_UP) {
      if (!keyDown) {
        if (_stateTmer <= DOT_TIME) {
          _inputState = WAITING_FOR_KEY_DOWN;
          _stateTimer = 0;
          _inputWord.add(InputType.DOT);
        } else if (_stateTmer <= DASH_TIME) {
          _inputState = WAITING_FOR_KEY_DOWN;
          _stateTimer = 0;
          _inputWord.add(InputType.DASH);
        }
      } else {
        _stateTimer += deltaTime; 
        if (_stateTmer > DASH_TIME){ // if held too long will reset input sequence
          _inputState = WAITING_TO_START;
          _stateTimer = 0;
        }
      }
    } else if (_inputState == WAITING_FOR_KEY_DOWN) {
      if(keyDown) {        
        _inputState = WAITING_FOR_KEY_UP;
        _stateTimer = 0;
      } else {
        _stateTimer += deltaTime; 
        if (_stateTmer > PAUSE_TIME){ // pausing for long time will end sequence
          _processedWords.add(_inputWord.copy());
          _inputState = WAITING_TO_START;
          _stateTimer = 0;
        }
      }
    } else {
      // INVALID STATE!!!
    }
  }
  
  ArrayList<InputType> getCurrentWord() {
    return _inputWord;
  }
  
  ArrayList<InputType> getNextWord() {
    if(_processedWords.size() > 0) {
      return _processedWords.remove(0);
    } else {
      return null;
    }
  }
  
}
