#!/bin/sh

echo "start: ***** Generated GoogleService-info *****"

if [ "${CONFIGURATION}" = "Production" ]; then
  cp -r "${SRCROOT}/Kikurage/Utility/Plist/Firebase/GoogleService-Info-Production.plist" "${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app/GoogleService-Info.plist"
  echo "Success GoogleService-Info for Production."
elif [ "${CONFIGURATION}" = "Staging" ]; then
  cp -r "${SRCROOT}/Kikurage/Utility/Plist/Firebase/GoogleService-Info-Staging.plist" "${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app/GoogleService-Info.plist"
  echo "Success GoogleService-Info for Staging."
elif [ "${CONFIGURATION}" = "Debug" ]; then
  cp -r "${SRCROOT}/Kikurage/Utility/Plist/Firebase/GoogleService-Info-Production.plist" "${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app/GoogleService-Info.plist"
  echo "Success GoogleService-Info for Debug."
else
  echo "Failed"
fi

echo "end: ***** Generated GoogleService-info *****"