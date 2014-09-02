/**
 * Flone, The flying phone
 * By Lot Amorós from Aeracoop
 * GPL v3
 * http://flone.aeracoop.net
 */

//cdataarray

cDataArray
accPITCH   = new cDataArray(200), accROLL    = new cDataArray(200), accYAW     = new cDataArray(200), 
gyroPITCH  = new cDataArray(200), gyroROLL   = new cDataArray(200), gyroYAW    = new cDataArray(200), 
magxData   = new cDataArray(200), magyData   = new cDataArray(200), magzData   = new cDataArray(200), 
altData    = new cDataArray(200), headData   = new cDataArray(200), 
debug1Data = new cDataArray(200), debug2Data = new cDataArray(200), debug3Data = new cDataArray(200), debug4Data = new cDataArray(200);



class cDataArray {
  private float[] m_data;
  private int m_maxSize, m_startIndex = 0, m_endIndex = 0, m_curSize;
  
  cDataArray(int maxSize){
    m_maxSize = maxSize;
    m_data = new float[maxSize];
  }
  void addVal(float val) {
    m_data[m_endIndex] = val;
    m_endIndex = (m_endIndex+1)%m_maxSize;
    if (m_curSize == m_maxSize) {
      m_startIndex = (m_startIndex+1)%m_maxSize;
    } else {
      m_curSize++;
    }
  }
  float getVal(int index) {return m_data[(m_startIndex+index)%m_maxSize];}
  int getCurSize(){return m_curSize;}
  int getMaxSize() {return m_maxSize;}
  float getMaxVal() {
    float res = 0.0;
    for(int i=0; i<m_curSize-1; i++) if ((m_data[i] > res) || (i==0)) res = m_data[i];
    return res;
  }
  float getMinVal() {
    float res = 0.0;
    for(int i=0; i<m_curSize-1; i++) if ((m_data[i] < res) || (i==0)) res = m_data[i];
    return res;
  }
  float getRange() {return getMaxVal() - getMinVal();}
}
