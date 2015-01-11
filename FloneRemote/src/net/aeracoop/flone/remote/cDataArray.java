package net.aeracoop.flone.remote;

/**
 * Flone, The flying phone
 * By Lot Amoros from Aeracoop
 * GPL v3
 * http://flone.aeracoop.net
 */

class cDataArray {
  private float[] m_data;
  private int m_maxSize, m_startIndex = 0, m_endIndex = 0, m_curSize;
  
  cDataArray(int maxSize){
    m_maxSize = maxSize;
    m_data = new float[maxSize];
  }
  public void addVal(float val) {
    m_data[m_endIndex] = val;
    m_endIndex = (m_endIndex+1)%m_maxSize;
    if (m_curSize == m_maxSize) {
      m_startIndex = (m_startIndex+1)%m_maxSize;
    } else {
      m_curSize++;
    }
  }
  public float getVal(int index) {return m_data[(m_startIndex+index)%m_maxSize];}
  public int getCurSize(){return m_curSize;}
  public int getMaxSize() {return m_maxSize;}
  public float getMaxVal() {
    float res = 0.0f;
    for(int i=0; i<m_curSize-1; i++) if ((m_data[i] > res) || (i==0)) res = m_data[i];
    return res;
  }
  public float getMinVal() {
    float res = 0.0f;
    for(int i=0; i<m_curSize-1; i++) if ((m_data[i] < res) || (i==0)) res = m_data[i];
    return res;
  }
  public float getRange() {return getMaxVal() - getMinVal();}
}