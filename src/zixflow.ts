/**
 * Zixflow SDK - Main entry point
 *
 * This provides the Zixflow-branded API that wraps the underlying Customer.io implementation.
 */

import { CustomerIO } from './customerio-cdp';
import { CustomerIOInAppMessaging } from './customerio-inapp';
import { CustomerIOLocation } from './customerio-location';
import { CustomerIOPushMessaging } from './customerio-push';

// Re-export the CustomerIO class as Zixflow for branding
export const Zixflow = CustomerIO;

// Re-export all types and utilities
export * from './types';
export * from './notification-inbox';

// Export sub-modules with their original names (they work with the main Zixflow class)
export {
  CustomerIOInAppMessaging,
  CustomerIOLocation,
  CustomerIOPushMessaging,
};
