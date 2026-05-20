import { ScreensContext } from '@screens-context';
import React, { useContext, useEffect, useState } from 'react';
import { StyleSheet, View } from 'react-native';
import { systemWeights } from 'react-native-typography';
import { SmallFootnote } from './text';

export const BuildInfoText = () => {
  const [buildInfo, setBuildInfo] = useState('');
  const { appName } = useContext(ScreensContext);
  useEffect(() => {
    const sdkPackageJson = require('zixflow-reactnative/package.json');

    const value = `Zixflow RN SDK version ${sdkPackageJson.version}`;
    setBuildInfo(value);
  }, [buildInfo]);

  return (
    <View style={styles.container}>
      <SmallFootnote>
        <SmallFootnote style={styles.flavorText}>{appName}</SmallFootnote>{' '}
        Sample App
      </SmallFootnote>
      <SmallFootnote>{buildInfo}</SmallFootnote>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    alignItems: 'center',
    justifyContent: 'center',
    marginVertical: 16,
  },

  flavorText: {
    ...systemWeights.bold,
  },
});

export default BuildInfoText;
